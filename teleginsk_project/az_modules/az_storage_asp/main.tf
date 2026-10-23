# Sufixo aleatório: nomes de Storage Account e Function App precisam ser únicos em toda a Azure.
resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  suffix = random_id.suffix.hex
}

resource "azurerm_storage_account" "storage" {
  name                     = "stasp${local.suffix}"
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  # A Function App lê o pacote e o próprio estado neste storage.
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "container" {
  name                  = "function"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = var.function_source_dir
  output_path = "${path.root}/.build/function.zip"
}

resource "azurerm_storage_blob" "function_blob" {
  name                   = "function-${data.archive_file.function_zip.output_md5}.zip"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = data.archive_file.function_zip.output_path
}

# Link de leitura (SAS) do pacote, válido por 1 ano a partir da criação.
resource "time_static" "sas_start" {}

data "azurerm_storage_account_blob_container_sas" "function" {
  connection_string = azurerm_storage_account.storage.primary_connection_string
  container_name    = azurerm_storage_container.container.name
  https_only        = true
  start             = time_static.sas_start.rfc3339
  expiry            = timeadd(time_static.sas_start.rfc3339, "8760h")

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

# B1: menor plano que roda Function App em Linux com integração de rede.
resource "azurerm_service_plan" "asp" {
  name                = "asp-${local.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = "func-${local.suffix}"
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  virtual_network_subnet_id  = var.function_subnet_id
  https_only                 = true

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "${azurerm_storage_blob.function_blob.url}${data.azurerm_storage_account_blob_container_sas.function.sas}"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
}

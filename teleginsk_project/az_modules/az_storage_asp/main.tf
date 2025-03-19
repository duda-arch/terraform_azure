resource "azurerm_storage_account" "mystorageaqui" {
  name                     = "storage0asp"
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  public_network_access_enabled = false
}

resource "azurerm_storage_container" "container" {
  name                  = "function"
  storage_account_name  = azurerm_storage_account.mystorageaqui.name
  container_access_type = "blob" 
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "../asp_scripts_py"
  output_path = "../asp_scripts_py.zip"
}

resource "azurerm_storage_blob" "function_blob" {
  name                   = "asp_scripts_py.zip"
  storage_account_name   = azurerm_storage_account.mystorageaqui.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = data.archive_file.function_zip.output_path
}

resource "azurerm_service_plan" "asp" {
  name                = "asp"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "F1"

}

resource "azurerm_linux_function_app" "function_app" {
  name                       = "func"
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.mystorageaqui.name
  storage_account_access_key = azurerm_storage_account.mystorageaqui.primary_access_key
  virtual_network_subnet_id  = var.subnet_id

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python3.7"              
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.mystorageaqui.name}.blob.core.windows.net/${azurerm_storage_container.container.name}/${azurerm_storage_blob.function_blob.name}"
  }

  site_config {
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  for_each = { for key, value in var.vms : key => value if value.with_vm == false }

  app_service_id = azurerm_linux_function_app.function_app.id
  subnet_id      = var.subnet_id[each.key]
}
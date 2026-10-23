resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

module "az_firewall" {
  source                  = "./az_modules/az_firewall"
  firewall_name           = "firewall"
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  vnet_name               = "AzureFirewallVNet"
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_name             = "AzureFirewallSubnet"
  subnet_address_space    = ["10.0.0.0/26"]
  icmp_rules              = var.icmp_rules
  https_rules             = var.https_rules
}

module "az_networking" {
  source                  = "./az_modules/az_networking"
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  vms                     = local.vms
  security_rule           = var.security_rule
}

module "az_perring" {
  source                      = "./az_modules/az_perring"
  resource_group_name         = azurerm_resource_group.rg.name
  resource_group_location     = azurerm_resource_group.rg.location
  vms                         = local.vms
  vnet_id                     = module.az_networking.vnet_id
  vnet_name                   = module.az_networking.vnet_name
  subnet_id                   = module.az_networking.subnet_id
  firewall_vnet_name          = module.az_firewall.vnet_name
  firewall_vnet_id            = module.az_firewall.vnet_id
  firewall_private_ip_address = module.az_firewall.firewall_private_ip_address
}

module "az_vm" {
  source                  = "./az_modules/az_vm"
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  vms                     = local.vms
  nic_vm_id               = module.az_networking.nic_id
}

module "az_storage_asp" {
  source                  = "./az_modules/az_storage_asp"
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  function_subnet_id      = module.az_networking.function_subnet_id
  function_source_dir     = "${path.root}/asp_scripts_py"
}

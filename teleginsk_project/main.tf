module "az_firewall" {
    firewall_name = "firewall"
    source = "./az_modules/az_firewall"
    resource_group_name = var.resource_group_name
    resource_group_location = var.resource_group_location
    resource_group_id = azurerm_resource_group.rg.id
    vnet_name = "AzureFirewallVNet"
    vnet_address_space = ["10.0.0.0/16"]
    subnet_name = "AzureFirewallSubnet"
    subnet_address_space = ["10.0.0.0/26"]
    icmp_rules = var.icmp_rules 
    https_rules = var.https_rules
}

module "az_networking" { 
    source = "./az_modules/az_networking"
    resource_group_name = var.resource_group_name
    resource_group_location = var.resource_group_location
    vms = var.vms
    security_rule = var.security_rule

}

module "az_perring" {
    source = "./az_modules/az_perring"
    resource_group_name = var.resource_group_name
    resource_group_location = var.resource_group_location
    vms = var.vms
    vnet_id = module.az_networking.vnet_id
    vnet_name = module.az_networking.vnet_name
    vnet_address_space = module.az_networking.vnet_address_space
    firewall_vnet_name = module.az_firewall.vnet_name
    firewall_vnet_id = module.az_firewall.vnet_id
    firewall_private_ip_address = module.az_firewall.firewall_private_ip_address
    subnet_id = module.az_networking.subnet_id
}

module "az_vm" {
    source = "./az_modules/az_vm"
    resource_group_name = var.resource_group_name
    resource_group_location = var.resource_group_location
    vms = var.vms
    nic_vm_id = module.az_networking.nic_id
    mystorageaqui_primary_blob_endpoint = var.mystorageaqui_primary_blob_endpoint#
}


module "az_storage_asp" {
    source = "./az_modules/az_storage_asp"
    resource_group_name = var.resource_group_name
    resource_group_location = var.resource_group_location
    vms = var.vms
    subnet_id = module.az_networking.subnet_id
    subnet_vmc_id = module.az_networking.subnet_id_vmc
}
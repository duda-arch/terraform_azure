output "firewall_vnet_id" {
    value = azurerm_virtual_network.firewall_vnet.id
}

output "firewall_vnet_name" {
    value = azurerm_virtual_network.firewall_vnet.name
}

output "firewall_ip_configuration_private_ip_address" {
    value =  azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}
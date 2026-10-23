output "vnet_id" {
  value = azurerm_virtual_network.firewall_vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.firewall_vnet.name
}

output "firewall_private_ip_address" {
  value = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  value = azurerm_public_ip.firewall_public_ip.ip_address
}

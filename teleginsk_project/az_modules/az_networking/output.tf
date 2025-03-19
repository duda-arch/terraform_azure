output "vnet_name" {
  value = { for k, v in azurerm_virtual_network.vnet : k => v.name }
}

output "subnet_id" {
  value = { for k, v in azurerm_subnet.subnet : k => v.id }
}

output "subnet_id_vmc" {
  value = azurerm_subnet.subnet["vm_c"].id
} 

output "address_space" {
  value = { for k, v in azurerm_virtual_network.vnet : k => v.address_space }
}

output "nic_id" {
  value = { for k, v in azurerm_network_interface.nic_vm : k => v.id }
}

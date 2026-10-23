output "vnet_id" {
  value = { for k, v in azurerm_virtual_network.vnet : k => v.id }
}

output "vnet_name" {
  value = { for k, v in azurerm_virtual_network.vnet : k => v.name }
}

output "subnet_id" {
  value = { for k, v in azurerm_subnet.subnet : k => v.id }
}

output "nic_id" {
  value = { for k, v in azurerm_network_interface.nic_vm : k => v.id }
}

output "function_subnet_id" {
  description = "Subnet usada pela Function App (o item com with_vm = false)."
  value       = one([for k, v in azurerm_subnet.subnet : v.id if !var.vms[k].with_vm])
}

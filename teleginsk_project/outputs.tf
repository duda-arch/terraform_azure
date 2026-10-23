output "firewall_public_ip" {
  description = "IP público do Azure Firewall."
  value       = module.az_firewall.firewall_public_ip
}

output "function_app_hostname" {
  description = "Endereço da Function App."
  value       = module.az_storage_asp.function_app_hostname
}

output "vm_private_keys" {
  description = "Chaves SSH privadas das VMs. Veja com: terraform output -json vm_private_keys"
  value       = module.az_vm.vm_private_keys
  sensitive   = true
}

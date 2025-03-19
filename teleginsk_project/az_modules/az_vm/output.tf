output "vm_public_keys" {
  value = { for k, v in tls_private_key.vm : k => v.public_key_openssh }
}

output "vm_private_keys" {
  value     = { for k, v in tls_private_key.vm : k => v.private_key_pem }
  sensitive = true
}
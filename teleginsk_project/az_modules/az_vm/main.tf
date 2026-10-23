locals {
  vm_envs = { for key, value in var.vms : key => value if value.with_vm }
}

resource "tls_private_key" "vm" {
  for_each = local.vm_envs

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = local.vm_envs

  name                  = each.value.name
  computer_name         = each.value.name
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  size                  = each.value.size
  admin_username        = each.value.admin_username
  network_interface_ids = [var.nic_vm_id[each.key]]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = tls_private_key.vm[each.key].public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Sem storage_account_uri, a Azure usa uma conta de armazenamento gerenciada.
  boot_diagnostics {}
}

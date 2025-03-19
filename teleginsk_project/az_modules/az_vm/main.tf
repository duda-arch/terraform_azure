resource "random_id" "storage_account" {
  byte_length = 8
}

resource "tls_private_key" "vm" {
  for_each = { for key, value in var.vms : key => value if value.with_vm == true }

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_ssh_public_key" "vm" {
  for_each = { for key, value in var.vms : key => value if value.with_vm == true }

  name      = "ssh_vm_${each.value.name}"
  public_key = tls_private_key.vm[each.key].public_key_openssh
  resource_group_name = var.resource_group_name
  location  = var.resource_group_location
}

resource "azurerm_linux_virtual_machine" "vm" {

  for_each = { for key, value in var.vms : key => value if value.with_vm == true }

  name                  = each.value.name
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  size                  = each.value.size
  admin_username        = each.value.admin_username
  network_interface_ids = [var.nic_vm_id[each.key]]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = azurerm_ssh_public_key.vm[each.key].public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name = each.value.name

  boot_diagnostics {
    storage_account_uri = var.mystorageaqui_primary_blob_endpoint
  }
}
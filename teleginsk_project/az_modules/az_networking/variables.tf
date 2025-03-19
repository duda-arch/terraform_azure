variable "resource_group_name" {
  type        = string
  description = "resource_group_name"
}

variable "resource_group_location" {
  type        = string
  description = "resource_group_location"
}

variable vms {
  type = map(object({
    with_vm      = bool
    suffix       = string
    name         = string
    size         = string
    username     = string
    admin_username = string
    admin_password = string
    vnet_address_space          = list(string)
    subnet_address_prefixes     = list(string)
    nic_private_ip_address      = string
  }))
  description = "vms"
}

variable security_rule {
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "security_rule"
}

variable "resource_group_name" {
  type        = string
  description = "Nome do resource group."
}

variable "resource_group_location" {
  type        = string
  description = "Região do resource group."
}

variable "vms" {
  type = map(object({
    with_vm                 = bool
    suffix                  = string
    name                    = string
    size                    = string
    username                = string
    admin_username          = string
    vnet_address_space      = list(string)
    subnet_address_prefixes = list(string)
    nic_private_ip_address  = string
  }))
  description = "Ambientes: cada item vira uma VM (with_vm = true) ou a rede da Function App (with_vm = false)."
}

variable "security_rule" {
  type = list(object({
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
  description = "Regras do Network Security Group das VMs."
}

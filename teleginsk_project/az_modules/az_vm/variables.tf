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

variable "nic_vm_id" {
  type        = map(string)
  description = "ID da interface de rede de cada VM."
}

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

variable "vnet_id" {
  type        = map(string)
  description = "ID de cada VNet, por ambiente."
}

variable "vnet_name" {
  type        = map(string)
  description = "Nome de cada VNet, por ambiente."
}

variable "subnet_id" {
  type        = map(string)
  description = "ID de cada subnet, por ambiente."
}

variable "firewall_vnet_name" {
  type        = string
  description = "Nome da VNet hub do firewall."
}

variable "firewall_vnet_id" {
  type        = string
  description = "ID da VNet hub do firewall."
}

variable "firewall_private_ip_address" {
  type        = string
  description = "IP privado do firewall, usado como próximo salto das rotas."
}

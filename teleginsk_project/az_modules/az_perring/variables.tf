variable "resource_group_name" {
  type        = string
  description = "resource_group_name"
}

variable "resource_group_location" {
  type        = string
  description = "resource_group_location"
}

variable "vms" {
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

variable "vnet_id" {
  type        = string
  description = "vnet_id"
}

variable "vnet_name" {
  type        = list(string)
  description = "vnet_name"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "vnet_address_space"
}


variable "firewall_vnet_name" {
  type    = string
  description = "firewall_vnet_name"
}

variable "firewall_vnet_id" {
  type        = string
  description = "firewall_vnet_id"
}

variable "firewall_private_ip_address" {
  type        = string
  description = "firewall_private_ip_address"
}

variable "subnet_id" {
  type    = list(string)
  description = "subnet_id"
}

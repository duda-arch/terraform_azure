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

variable "nic_vm_id" {
  type        = string
  description = "nic_vm_id"
}

variable "mystorageaqui_primary_blob_endpoint" {
  type        = string
  description = "mystorageaqui_primary_blob_endpoint"
}

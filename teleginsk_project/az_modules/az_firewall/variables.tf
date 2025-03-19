variable "firewall_name" {
  type        = string
  description = "firewall_name"
}

variable "resource_group_name" {
  type        = string
  description = "resource_group_name"
}

variable "resource_group_location" {
  type        = string
  description = "resource_group_location"
}

variable "resource_group_id" {
  type        = string
  description = "resource_group_id"
}

variable "icmp_rules" {
  type        = list(object({
    name                  = string
    protocols             = list(string)
    source_addresses      = list(string)
    destination_addresses = list(string)
    destination_ports     = list(string)
  }))
  description = "icmp_rules"
}

variable "https_rules" {
  type        = list(object({
    name             = string
    source_addresses = list(string)
    target_fqdns     = list(string)
    protocol = list(object({
      type = string
      port = number
    }))
  }))
  description = "https_rules"
}
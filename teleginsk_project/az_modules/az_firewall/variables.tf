variable "firewall_name" {
  type        = string
  description = "Nome do Azure Firewall."
}

variable "resource_group_name" {
  type        = string
  description = "Nome do resource group."
}

variable "resource_group_location" {
  type        = string
  description = "Região do resource group."
}

variable "vnet_name" {
  type        = string
  description = "Nome da VNet hub, onde fica o firewall."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Faixa de endereços da VNet hub."
}

variable "subnet_name" {
  type        = string
  description = "Nome da subnet do firewall. A Azure exige o nome AzureFirewallSubnet."
}

variable "subnet_address_space" {
  type        = list(string)
  description = "Faixa da subnet do firewall (no mínimo /26)."
}

variable "icmp_rules" {
  type = list(object({
    name                  = string
    protocols             = list(string)
    source_addresses      = list(string)
    destination_addresses = list(string)
    destination_ports     = list(string)
  }))
  description = "Regras de rede (ICMP) liberadas no firewall."
}

variable "https_rules" {
  type = list(object({
    name             = string
    source_addresses = list(string)
    target_fqdns     = list(string)
    protocol = object({
      type = string
      port = number
    })
  }))
  description = "Regras de aplicação (HTTPS) liberadas no firewall."
}

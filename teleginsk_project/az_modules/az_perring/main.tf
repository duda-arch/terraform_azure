resource "azurerm_virtual_network_peering" "vnet_to_firewall" {
  for_each = var.vms

  name                         = "peer${each.value.suffix}2F"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.vnet_name[each.key]
  remote_virtual_network_id    = var.firewall_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "firewall_to_vnet" {
  for_each = var.vms

  name                         = "peerF2${each.value.suffix}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.firewall_vnet_name
  remote_virtual_network_id    = var.vnet_id[each.key]
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_route_table" "rt_vnet" {
  for_each = var.vms

  name                = "rt-vnet${each.value.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# Rota padrão: todo o tráfego que sai da subnet (para a internet ou para outra VNet)
# passa pelo firewall, que aplica as regras de ICMP e HTTPS.
resource "azurerm_route" "route_vnet_to_firewall" {
  for_each = var.vms

  name                   = "vnet${each.value.suffix}-to-firewall"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.rt_vnet[each.key].name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip_address
}

resource "azurerm_subnet_route_table_association" "subnet_route_assoc" {
  for_each = var.vms

  subnet_id      = var.subnet_id[each.key]
  route_table_id = azurerm_route_table.rt_vnet[each.key].id
}

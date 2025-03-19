resource "azurerm_virtual_network_peering" "vnet_to_firewall" {
  for_each = local.vms

  name                      = "peer${each.value.suffix}2F"
  resource_group_name       = var.resource_group_name

  virtual_network_name      = var.vnet_name[each.key]
  remote_virtual_network_id = var.firewall_vnet_id

  # virtual_network_name      = azurerm_virtual_network.vnet[each.key].name
  # remote_virtual_network_id = azurerm_virtual_network.firewall_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "firewall_to_vnet" {
  for_each = local.vms

  name                      = "peerF2${each.value.suffix}"
  resource_group_name       = var.resource_group_name

  virtual_network_name      = var.firewall_vnet_name
  remote_virtual_network_id = vnet_id[each.key]

  # virtual_network_name      = azurerm_virtual_network.firewall_vnet.name
  # remote_virtual_network_id = azurerm_virtual_network.vnet[each.key].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

}

resource "azurerm_route_table" "rt_vnet" {
  for_each = local.vms

  name                = "rt-vnet${each.value.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "route_vnet_to_firewall" {
  for_each = local.vms

  name                   = "vnet${each.value.suffix}_to-firewall"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.rt_vnet[each.key].name
  next_hop_type          = "VirtualAppliance"

  address_prefix         = tolist(var.vnet_address_space[each.key])[0]
  next_hop_in_ip_address = var.firewall_private_ip_address

  # next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  # address_prefix         = tolist(azurerm_virtual_network.vnet[each.key].address_space)[0]
}

resource "azurerm_subnet_route_table_association" "subnet_route_assoc" {
  for_each = local.vms

  subnet_id      = var.subnet_id[each.key]
  route_table_id = azurerm_route_table.rt_vnet[each.key].id
}
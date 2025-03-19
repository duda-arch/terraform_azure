resource "azurerm_virtual_network" "vnet" {
  for_each = local.vms

  name                = "vnet-${each.value.suffix}"
  address_space       = each.value.vnet_address_space
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  for_each = local.vms

  name                 = "subnet-${each.value.suffix}"
  address_prefixes     = each.value.subnet_address_prefixes
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_interface" "nic_vm" {
  for_each = local.vms

  name                = "nic-vm-${each.value.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig-vm-${each.value.suffix}"
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.nic_private_ip_address
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "myNetworkSecurityGroup"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  dynamic security_rule {
    for_each = var.security_rule
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each = local.vms

  network_interface_id      = azurerm_network_interface.nic_vm[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-sub2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Associate NSG with PE Subnet
resource "azurerm_subnet_network_security_group_association" "assoc_app2_sub" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "nsg-rule-1" {
  name                        = "deny-all"
  priority                    = 4096  # Lowest priority, so it applies last
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_group" "nsg-2" {
  name                = "nsg-sub3"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Associate NSG with PE Subnet
resource "azurerm_subnet_network_security_group_association" "assoc_pe_sub" {
  subnet_id                 = azurerm_subnet.subnet3.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "nsg-rule-2" {
  name                        = "deny-all"
  priority                    = 4096  # Lowest priority, so it applies last
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"

  resource_group_name         = azurerm_resource_group.rg.name
  destination_address_prefix  = azurerm_private_endpoint.app2_pe.private_service_connection[0].private_ip_address
  network_security_group_name = azurerm_network_security_group.nsg-2.name
}
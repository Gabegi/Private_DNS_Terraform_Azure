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
  priority                    = 200  # Lowest priority, so it applies last
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name

  destination_port_range      = "*"
  source_port_range           = "*"

  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_subnet.subnet2.address_prefixes[0] 
  
}

resource "azurerm_network_security_rule" "nsg-rule-allow-private-endpoint" {
  name                        = "allow-pe-to-app2"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
  
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"

  source_address_prefix       = azurerm_subnet.subnet3.address_prefixes[0]  # Private endpoint subnet
  destination_address_prefix  = azurerm_subnet.subnet2.address_prefixes[0]  # App2 subnet
  
}


//////////////////////// Subnet 3 NSG //////////////////////////////////////
resource "azurerm_network_security_group" "nsg-2" {
  name                = "nsg-sub3"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Associate NSG with PE Subnet
resource "azurerm_subnet_network_security_group_association" "assoc_pe_sub" {
  subnet_id                 = azurerm_subnet.subnet3.id
  network_security_group_id = azurerm_network_security_group.nsg-2.id
}

resource "azurerm_network_security_rule" "deny-all-to-subnet3" {
  name                        = "deny-all-to-app2"
  priority                    = 200  # Lowest priority, so it applies last
  direction                   = "Inbound"
  access                      = "Deny"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-2.name

    protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"

  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_private_endpoint.app2_pe.private_service_connection[0].private_ip_address  # Block only PE2
}

resource "azurerm_network_security_rule" "nsg-rule-3" {
  name                        = "allow-app1-to-app2"
  priority                    = 100  # Lowest priority, so it applies last
  direction                   = "Inbound"
  access                      = "Allow"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-2.name

  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"

  source_address_prefix       = azurerm_subnet.subnet1.address_prefixes[0]  # Only allow App1 Subnet
  destination_address_prefix  = azurerm_private_endpoint.app2_pe.private_service_connection[0].private_ip_address  # Block only PE2
}
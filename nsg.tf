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
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_subnet.subnet2.address_prefixes[0] 
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "deny-public-to-app2" {
  name                        = "deny-public-to-app2"
  priority                    = 1000  # Low priority, ensuring it applies last
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_private_endpoint.app2_pe.private_service_connection[0].private_ip_address
  network_security_group_name = azurerm_network_security_group.nsg-2.name
  resource_group_name         = azurerm_resource_group.rg.name
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

resource "azurerm_network_security_rule" "nsg-rule-2" {
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
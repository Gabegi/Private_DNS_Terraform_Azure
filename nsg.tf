//////////////////////// Subnet 2 NSG //////////////////////////////////////
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-sub2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "deny-all"
    priority                   = 250  # Lowest priority, so it applies last
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.subnet2.address_prefixes[0]
  }

  security_rule {
  name                       = "deny-all"
  priority                   = 300
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "VirtualNetwork"  # Explicitly deny VNet traffic
  destination_address_prefix = azurerm_subnet.subnet2.address_prefixes[0]
}

security_rule {
  name                       = "deny-external"
  priority                   = 200
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "Internet"  # Blocks only external traffic
  destination_address_prefix = azurerm_subnet.subnet2.address_prefixes[0]
}

security_rule {
  name                       = "deny-external"
  priority                   = 190  # Ensure it is higher priority than default rules
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix = azurerm_private_endpoint.app2_pe.private_service_connection[0].private_ip_address
  destination_address_prefix = azurerm_subnet.subnet2.address_prefixes[0]
}



}

resource "azurerm_subnet_network_security_group_association" "assoc_app2_sub" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

//////////////////////// Subnet 3 NSG //////////////////////////////////////
resource "azurerm_network_security_group" "nsg-2" {
  name                = "nsg-sub3"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "deny-all"
    priority                   = 200  # Lowest priority, so it applies last
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.subnet2.address_prefixes[0]
  }
}

# Associate NSG with PE Subnet
resource "azurerm_subnet_network_security_group_association" "assoc_pe_sub" {
  subnet_id                 = azurerm_subnet.subnet3.id
  network_security_group_id = azurerm_network_security_group.nsg-2.id
}

//////////////////////// Subnet 1 NSG //////////////////////////////////////
resource "azurerm_network_security_group" "nsg-1" {
  name                = "nsg-1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "deny-all"
    priority                   = 200  # Lowest priority, so it applies last
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.subnet1.address_prefixes[0]
  }
}

resource "azurerm_subnet_network_security_group_association" "assoc_app1_sub" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg-1.id
}


# resource "azurerm_network_security_rule" "nsg-1-rule-allow-sub1-tosub3-outbound" {
#   name                        = "allow-sub1-to-sub3"
#   priority                    = 150
#   direction                   = "Outbound"
#   access                      = "Allow"
#   network_security_group_name = azurerm_network_security_group.nsg-1.name
#   resource_group_name         = azurerm_resource_group.rg.name
  
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"

#   source_address_prefix       = azurerm_subnet.subnet1.address_prefixes[0]  # Private endpoint subnet
#   destination_address_prefix  = azurerm_subnet.subnet3.address_prefixes[0]  # App2 subnet
  
# }

# resource "azurerm_network_security_rule" "allow-sub1-to-sub2-outbound" {
#   name                        = "allow-sub1-to-sub2"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   network_security_group_name = azurerm_network_security_group.nsg-1.name
#   resource_group_name         = azurerm_resource_group.rg.name

#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = azurerm_subnet.subnet1.address_prefixes[0]  # App1 Subnet
#   destination_address_prefix  = azurerm_subnet.subnet2.address_prefixes[0]  # App2 Subnet
# }

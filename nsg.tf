//////////////////////// Subnet 2 NSG //////////////////////////////////////
resource "azurerm_network_security_group" "nsg-sub2" {
  name                = "nsg-sub2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 150  # Lowest priority, so it applies first
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*" 
    destination_address_prefix = "*"
  }

    # Block Virtual network communication
  security_rule {
    name                       = "BlockVnetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

    # Deny all inbound traffic from the internet
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "subnet2-nsg2" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg-sub2.id
}

//////////////////////// Subnet 3 NSG //////////////////////////////////////
resource "azurerm_network_security_group" "nsg-2" {
  name                = "nsg-sub3"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

   # Block ALL inbound traffic
  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with subnet3 Sbnet
resource "azurerm_subnet_network_security_group_association" "assoc_pe_sub" {
  subnet_id                 = azurerm_subnet.subnet3.id
  network_security_group_id = azurerm_network_security_group.nsg-2.id
}

# //////////////////////// Subnet 1 NSG //////////////////////////////////////
# resource "azurerm_network_security_group" "nsg-1" {
#   name                = "nsg-sub1"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "deny-all"
#     priority                   = 200  # Lowest priority, so it applies last
#     direction                  = "Inbound"
#     access                     = "Deny"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = azurerm_subnet.subnet1.address_prefixes[0]
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "assoc_app1_sub" {
#   subnet_id                 = azurerm_subnet.subnet1.id
#   network_security_group_id = azurerm_network_security_group.nsg-1.id
# }



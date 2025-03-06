//////////////////////// Subnet 2 NSG //////////////////////////////////////
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-sub2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # security_rule {
  #   name                       = "deny-all"
  #   priority                   = 100  # Lowest priority, so it applies last
  #   direction                  = "Inbound"
  #   access                     = "Deny"
  #   protocol                   = "*"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "*" // "0.0.0.0/0"  # Deny from any external source
  #   destination_address_prefix = azurerm_subnet.subnet2.address_prefixes[0] // 20.105.224.37
  # }

  security_rule {
    name                       = "deny-all"
    priority                   = 100  # Lowest priority, so it applies last
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*" // "0.0.0.0/0"  # Deny from any external source
    destination_address_prefix = "20.105.224.0/24"
  }
    # Deny all inbound traffic from the internet
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # You can still allow specific internal traffic if needed
  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
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


# //////////////////////// Subnet 3 NSG //////////////////////////////////////
# resource "azurerm_network_security_group" "nsg-2" {
#   name                = "nsg-sub3"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#    # Block ALL inbound traffic
#   security_rule {
#     name                       = "deny-all-inbound"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Deny"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

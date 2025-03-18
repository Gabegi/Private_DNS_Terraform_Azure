# Public IP for Firewall
resource "azurerm_public_ip" "fw_pip" {
  name                = "fw-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                = "Standard"
}

# Azure Firewall
resource "azurerm_firewall" "fw" {
  name                = var.firewall_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_firewall.id
    private_ip_address   = var.firewall_private_ip
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}

# Route Table for App Subnet to Force Traffic Through Firewall
resource "azurerm_route_table" "rt" {
  name                          = "rt-firewall"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
}

# Route to Redirect All Traffic to Firewall
resource "azurerm_route" "default_route" {
  name                   = "route-to-firewall"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}
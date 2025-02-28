# resource "azurerm_route_table" "block_internet" {
#   name                = "block-internet-rt"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   route {
#     name           = "block-all-outbound"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "None"  # Blackhole traffic
#   }
# }

# resource "azurerm_subnet_route_table_association" "subnet2-block" {
#   subnet_id      = azurerm_subnet.subnet2.id  # The subnet hosting your Function App
#   route_table_id = azurerm_route_table.block_internet.id
# }

resource "azurerm_route_table" "app_route" {
  name                = "app-route"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_route" "app1_to_app2" {
  name                = "route-app1-to-app2"
  resource_group_name = azurerm_resource_group.rg.name
  route_table_name    = azurerm_route_table.app_route.name
  address_prefix      = azurerm_subnet.subnet2.address_prefixes[0] # App2 subnet
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.2.4" # If using Azure Firewall or a NAT Gateway
}

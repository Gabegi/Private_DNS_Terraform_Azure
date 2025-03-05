# resource "azurerm_route_table" "subnet2_route_table" {
#   name                          = "subnet2-route-table"
#   location                      = azurerm_resource_group.rg.location
#   resource_group_name           = azurerm_resource_group.rg.name
# }

# # Block ALL outbound internet traffic
# resource "azurerm_route" "block_internet" {
#   name                    = "block-internet"
#   resource_group_name     = azurerm_resource_group.rg.name
#   route_table_name        = azurerm_route_table.subnet2_route_table.name
#   address_prefix          = "0.0.0.0/0"  # Match all internet traffic
#   next_hop_type           = "None"       # DROP all internet traffic
# }

# # Associate the Route Table with subnet2
# resource "azurerm_subnet_route_table_association" "subnet2_route_assoc" {
#   subnet_id      = azurerm_subnet.subnet2.id
#   route_table_id = azurerm_route_table.subnet2_route_table.id
# }

resource "azurerm_route_table" "subnet3_route_table" {
  name                          = "subnet3-route-table"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
}

# Block ALL outbound internet traffic
resource "azurerm_route" "block_internet_subnet3" {
  name                    = "block-internet"
  resource_group_name     = azurerm_resource_group.rg.name
  route_table_name        = azurerm_route_table.subnet3_route_table.name
  address_prefix          = "0.0.0.0/0"  # Match all internet traffic
  next_hop_type           = "None"       # DROP all internet traffic
}

# Associate the Route Table with subnet3
resource "azurerm_subnet_route_table_association" "subnet3_route_assoc" {
  subnet_id      = azurerm_subnet.subnet3.id
  route_table_id = azurerm_route_table.subnet3_route_table.id
}

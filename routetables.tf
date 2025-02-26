resource "azurerm_route_table" "block_internet" {
  name                = "block-internet-rt"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name           = "block-all-outbound"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "None"  # Blackhole traffic
  }
}

resource "azurerm_subnet_route_table_association" "subnet2-block" {
  subnet_id      = azurerm_subnet.subnet2.id  # The subnet hosting your Function App
  route_table_id = azurerm_route_table.block_internet.id
}

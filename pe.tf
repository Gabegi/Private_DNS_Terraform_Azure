resource "azurerm_private_endpoint" "app1_pe" {
  name                = "app1-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet3.id

  private_service_connection {
    name                           = "app1-privateserviceconnection"
    private_connection_resource_id = azurerm_linux_function_app.app1.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "app2_pe" {
  name                = "app2-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet3.id

  private_service_connection {
    name                           = "app2-privateserviceconnection"
    private_connection_resource_id = azurerm_linux_function_app.app2.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
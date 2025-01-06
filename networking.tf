resource "azurerm_virtual_network" "vnet" {
  name                = "dns-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# # Private Endpoint for Function App 1
# resource "azurerm_private_endpoint" "function1_endpoint" {
#   name                = "function1-endpoint"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.subnet1.id

#   private_service_connection {
#     name                           = "function1-psc"
#     private_connection_resource_id = azurerm_function_app.function1.id
#     subresource_names              = ["sites"]
#   }
# }

# # Private Endpoint for Function App 2
# resource "azurerm_private_endpoint" "function2_endpoint" {
#   name                = "function2-endpoint"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.subnet2.id

#   private_service_connection {
#     name                           = "function2-psc"
#     private_connection_resource_id = azurerm_function_app.function2.id
#     subresource_names              = ["sites"]
#   }
# }

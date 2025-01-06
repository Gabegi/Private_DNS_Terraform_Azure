# # Storage account for Function Apps
# resource "azurerm_storage_account" "sa" {
#   name                     = "examplestoragename"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# # App Service Plan for Function Apps
# resource "azurerm_app_service_plan" "plan" {
#   name                = "example-plan"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku {
#     tier = "Dynamic"
#     size = "Y1"
#   }
# }

# # Function App 1
# resource "azurerm_function_app" "function1" {
#   name                       = "example-function1"
#   location                   = azurerm_resource_group.rg.location
#   resource_group_name        = azurerm_resource_group.rg.name
#   app_service_plan_id        = azurerm_app_service_plan.plan.id
#   storage_account_name       = azurerm_storage_account.sa.name
#   storage_account_access_key = azurerm_storage_account.sa.primary_access_key
# #   subnet_id                  = azurerm_subnet.subnet1.id
# }

# # Function App 2
# resource "azurerm_function_app" "function2" {
#   name                       = "example-function2"
#   location                   = azurerm_resource_group.rg.location
#   resource_group_name        = azurerm_resource_group.rg.name
#   app_service_plan_id        = azurerm_app_service_plan.plan.id
#   storage_account_name       = azurerm_storage_account.sa.name
#   storage_account_access_key = azurerm_storage_account.sa.primary_access_key
# #   subnet_id                  = azurerm_subnet.subnet2.id
# }
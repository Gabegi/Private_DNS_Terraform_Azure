# Storage account for Function Apps
resource "azurerm_storage_account" "sa1" {
  name                     = "dnsexamplesa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# App Service Plan for Function Apps
resource "azurerm_service_plan" "asp" {
  name                = "dns-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  sku_name            = "P1v2"
}

# Function App 1
resource "azurerm_windows_function_app" "app1" {
  name                = "dns-app1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.sa1.name
  storage_account_access_key = azurerm_storage_account.sa1.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id

  virtual_network_subnet_id = azurerm_subnet.subnet1.id

  site_config {
    application_stack {
      dotnet_version = "v8.0"
    }
}
}


# Function App 2
resource "azurerm_windows_function_app" "app2" {
  name                = "dns-app2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.sa1.name
  storage_account_access_key = azurerm_storage_account.sa1.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id

    virtual_network_subnet_id = azurerm_subnet.subnet2.id


  site_config {
    application_stack {
      dotnet_version = "v8.0"
    }
}
}
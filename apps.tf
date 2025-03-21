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
  sku_name            =  "P1v2" // "P4mv3"// 
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
    # application_stack {
    #   dotnet_version              = "v8.0" 
    #   use_dotnet_isolated_runtime = true 
    # }
    cors {
      allowed_origins = [
        "https://portal.azure.com"
      ]
      support_credentials = true
    }
    
}
app_settings = {
   "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app_insights.connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.app_insights.instrumentation_key
  }
   lifecycle {
    ignore_changes = [
      storage_account_access_key,
      site_config,
      app_settings,
      virtual_network_subnet_id,
      public_network_access_enabled
    ]
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

    # Disables Public Network Access
  public_network_access_enabled = false


  site_config {
    application_stack {
              dotnet_version              = "v8.0" 
              use_dotnet_isolated_runtime = true 
    }


    cors {
      allowed_origins = [
        "https://portal.azure.com"
      ]
      support_credentials = true
    }
}
app_settings = {
  "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app_insights.connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.app_insights.instrumentation_key
}
 lifecycle {
    ignore_changes = [
      storage_account_access_key,
      site_config,
      app_settings,
      virtual_network_subnet_id,
      public_network_access_enabled
    ]
  }
}
    
# Function App 2
resource "azurerm_windows_function_app" "app3" {
  name                = "dns-app3"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.sa1.name
  storage_account_access_key = azurerm_storage_account.sa1.primary_access_key
  service_plan_id            = azurerm_service_plan.asp2.id

  virtual_network_subnet_id = azurerm_subnet.subnet4.id

    # Disables Public Network Access
  // public_network_access_enabled = false
  site_config {
    application_stack {
              dotnet_version              = "v8.0" 
              use_dotnet_isolated_runtime = true 
    }

    cors {
      allowed_origins = [
        "https://portal.azure.com"
      ]
      support_credentials = true
    }
}
app_settings = {
  "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app_insights.connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.app_insights.instrumentation_key
}
 lifecycle {
    ignore_changes = [
      storage_account_access_key,
      site_config,
      app_settings,
      virtual_network_subnet_id,
      public_network_access_enabled
    ]
  }
}

resource "azurerm_service_plan" "asp2" {
  name                = "dns-asp2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  sku_name            =  "P1v2" // "P4mv3"// 
}
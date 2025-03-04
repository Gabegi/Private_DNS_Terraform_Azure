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


  # "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1" // allows to target different versions of .Net
  #   "WEBSITE_RUN_FROM_PACKAGE"          = "1"
  #   "WEBSITE_VNET_ROUTE_ALL" = "1"  # Ensures all outbound traffic uses VNet
  # "WEBSITE_DNS_SERVER"     = "20.105.224.40" 
  
  // "10.0.3.4"
  //"20.105.224.40"  # Uses Azure Private DNS
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
  # "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1" // allows to target different versions of .Net
  # "WEBSITE_RUN_FROM_PACKAGE"          = "1"
  # "WEBSITE_VNET_ROUTE_ALL"            = "1" // Ensures all outbound traffic goes through VNet
  # # "WEBSITE_PRIVATE_ENDPOINT_ENABLED"  = "1" // Ensures Private Endpoint is enforced
  # "WEBSITE_DNS_SERVER"                = "20.105.224.40"
  # //"10.0.3.5"
  # // "20.105.224.40" //"168.63.129.16" // Uses Azure's private DNS resolver
}

}



    #  # Enforce Private Network Access Only
    # ip_restriction {
    #   name                      = "Allow-Private-Endpoint"
    #   priority                  = 100
    #   action                    = "Allow"
    #   ip_address                 = null  # No specific IPs, use Virtual Network
    #   virtual_network_subnet_id = azurerm_subnet.subnet3.id  # Subnet hosting Private Endpoint
    # }

    # # Block ALL Public Access
    # ip_restriction {
    #   name     = "Deny-Public"
    #   priority = 200
    #   action   = "Deny"
    #   ip_address = "0.0.0.0/0"  # Blocks all public traffic
    # }
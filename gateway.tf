resource "azurerm_public_ip" "ip" {
  name                = "dns-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "gateway" {
  name                = "example-appgateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.subnet5.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.ip.id
  }

  backend_address_pool {
    name         = "app2-pe"
    ip_addresses = ["10.0.2.1"]
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80   # 🔹 Change from 443 to 80
    protocol              = "Http"   # 🔹 Change from Https to Http
    request_timeout       = 20
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "public-ip"
    frontend_port_name             = "http-port"  # 🔹 Matches frontend_port
    protocol                       = "Http"  # 🔹 Change from Https to Http
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "app2-pe"
    backend_http_settings_name = "http-settings"
  }
}


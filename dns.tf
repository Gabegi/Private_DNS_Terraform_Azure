resource "azurerm_private_dns_zone" "private_dns" {
  name                = "example.local"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "dns-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# A records for DNS
resource "azurerm_private_dns_a_record" "function1_dns" {
  name                = "function1"
  zone_name           = azurerm_private_dns_zone.private_dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.function1_endpoint.private_ip_address]
}

resource "azurerm_private_dns_a_record" "function2_dns" {
  name                = "function2"
  zone_name           = azurerm_private_dns_zone.private_dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.function2_endpoint.private_ip_address]
}
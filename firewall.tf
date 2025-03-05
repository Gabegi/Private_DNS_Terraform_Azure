# Azure Firewall
resource "azurerm_firewall" "fire-wall" {
  name                = "myFirewall"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
}


resource "azurerm_firewall_application_rule_collection" "deny_external_to_subnet2" {
  name                = "testcollection"
  azure_firewall_name = azurerm_firewall.fire-wall.name
  resource_group_name = azurerm_resource_group.rg.name
  priority            = 100
  action              = "Deny"

  rule {
    name                    = "blockExternalToSubnet2"
    source_addresses        = ["*"]  # Block all external traffic
    target_fqdns = [
      "*.azure.com",
    ]
    protocol {
      port = "443"
      type = "Https"
    }
  }
}

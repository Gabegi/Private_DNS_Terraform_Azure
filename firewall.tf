# Azure Firewall
resource "azurerm_firewall" "fire-wall" {
  name                = "myFirewall"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
#   firewall_policy_id  = azurerm_firewall_policy.firewall-policy1.id

  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
}

# # Azure Firewall Policy (This is where we define the blocking rules)
# resource "azurerm_firewall_policy" "firewall-policy1" {
#   name                = "myFirewallPolicy"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   rule_collection {
#     name     = "block_external_traffic"
#     action   = "Deny"
#     priority = 100

#     rule {
#       name             = "block_external"
#       protocol         = "Any"
#       source_addresses = ["*"]  # Source addresses: any (external)
#       destination_addresses = [azurerm_subnet.subnet2.address_prefixes[0]]  # Subnet2 destination
#       destination_ports = ["*"]
#     }
#   }
# }
# Azure Firewall
resource "azurerm_firewall" "fire-wall" {
  name                = "myFirewall"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  firewall_policy_id  = azurerm_firewall_policy.firewall-policy1.id

  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
}

resource "azurerm_firewall_policy" "firewall-policy1" {
  name                = "myFirewallPolicy"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_firewall_policy_rule_collection" "deny_external_to_subnet2" {
  name                = "denyExternalTrafficToSubnet2"
  priority            = 100
  action              = "Deny"
  rule_type           = "NetworkRule"
  firewall_policy_id = azurerm_firewall_policy.firewall-policy1.id

  rule {
    name                    = "blockExternalToSubnet2"
    source_addresses        = ["*"]  # Block all external traffic
    destination_addresses   = [azurerm_subnet.subnet2.address_prefixes[0]]  # Destination subnet2
    protocols               = ["Any"]  # Block all protocols (TCP, UDP, ICMP, etc.)
    destination_ports       = ["*"]  # Block all ports
  }
}

# Assign Firewall Policy to the Azure Firewall
resource "azurerm_firewall_policy_association" "firewall-policy-association" {
  firewall_policy_id = azurerm_firewall_policy.firewall-policy1.id
  firewall_id        = azurerm_firewall.fire-wall.id
}
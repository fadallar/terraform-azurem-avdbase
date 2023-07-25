resource "azurerm_subnet" "subnet" {
  name                                          = local.name
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = var.virtual_network_name
  address_prefixes                              = var.address_prefixes
  service_endpoints                             = var.service_endpoints
  service_endpoint_policy_ids                   = var.service_endpoint_policy_ids
  private_endpoint_network_policies_enabled     = var.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = var.enable_delegation == true ? ["enable_delegation"] : []
    content {
      name = var.delegation_name

      service_delegation {
        name    = var.service_delegation_name
        actions = var.service_delegation_actions
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  count                     = var.enable_network_security_group == true ? 1 : 0
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_subnet_route_table_association" "main" {
  count          = var.enable_route_table == true ? 1 : 0
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = var.route_table_id
}

resource "azurerm_subnet_nat_gateway_association" "main" {
  count          = var.enable_nat_gateway == true ? 1 : 0
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = var.nat_gateway_id
}
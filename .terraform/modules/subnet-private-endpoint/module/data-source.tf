/*
data "azurerm_route_table" "main" {
  count               = var.enable_route_table == true ? 1 : 0
  name                = var.route_table_name
  resource_group_name = var.route_table_resource_group_name
}

data "azurerm_nat_gateway" "main" {
  count               = var.enable_nat_gateway == true ? 1 : 0
  name                = var.nat_gateway_name
  resource_group_name = var.nat_gateway_resource_group_name
}

data "azurerm_network_security_group" "main" {
  count               = var.enable_network_security_group == true ? 1 : 0
  name                = var.network_security_group_name
  resource_group_name = var.network_security_group_resource_group_name
}

*/
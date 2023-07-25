output "subnet_name" {
  description = "Name of subnet created"
  value       = azurerm_subnet.subnet.name
}

output "subnet_id" {
  description = "The ID of the subnet created"
  value       = azurerm_subnet.subnet.id
}
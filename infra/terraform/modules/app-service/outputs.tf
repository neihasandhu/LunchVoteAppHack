output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.main.name
}

output "default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "principal_id" {
  description = "Principal ID of the App Service managed identity"
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}

output "service_plan_id" {
  description = "ID of the shared App Service Plan"
  value       = azurerm_service_plan.main.id
}

output "service_plan_name" {
  description = "Name of the shared App Service Plan"
  value       = azurerm_service_plan.main.name
}

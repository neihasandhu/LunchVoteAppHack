output "app_service_name" {
  description = "Name of the API App Service"
  value       = module.app_service.app_service_name
}

output "app_service_default_hostname" {
  description = "Default hostname of the API App Service"
  value       = module.app_service.default_hostname
}

output "api_url" {
  description = "Full HTTPS URL of the API"
  value       = "https://${module.app_service.default_hostname}"
}

output "app_service_principal_id" {
  description = "Principal ID of the API App Service managed identity"
  value       = module.app_service.principal_id
}

output "service_plan_name" {
  description = "Name of the shared App Service Plan (API + SPA)"
  value       = module.app_service.service_plan_name
}

output "frontend_app_service_name" {
  description = "Name of the Frontend App Service"
  value       = module.frontend_app_service.app_service_name
}

output "frontend_app_service_default_hostname" {
  description = "Default hostname of the Frontend App Service"
  value       = module.frontend_app_service.default_hostname
}

output "frontend_url" {
  description = "Full HTTPS URL of the Frontend"
  value       = module.frontend_app_service.url
}

output "frontend_app_service_principal_id" {
  description = "Principal ID of the Frontend App Service managed identity"
  value       = module.frontend_app_service.principal_id
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = module.sql_database.sql_server_fqdn
}

output "sql_database_name" {
  description = "Name of the SQL Database"
  value       = module.sql_database.database_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

output "static_web_app_default_hostname" {
  description = "Default hostname of the Static Web App"
  value       = var.deploy_static_web_app ? module.static_web_app[0].default_hostname : ""
}

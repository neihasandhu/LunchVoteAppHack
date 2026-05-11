# Main orchestration for Lunch Vote App infrastructure
# Deploys App Service, SQL Database, Key Vault, and Static Web App

# Data source for current Azure configuration
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.name}-${var.env}"
  location = var.location
}

# SQL Database Module
module "sql_database" {
  source = "./modules/sql-database"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sql_server_name     = "sql-${var.name}-${var.env}"
  sql_database_name   = "sqldb-${var.name}"
  sql_admin_object_id = var.sql_admin_object_id
  sql_admin_login     = var.sql_admin_login
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

# Key Vault Module
module "key_vault" {
  source = "./modules/key-vault"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  key_vault_name      = "kv-${var.name}-${var.env}"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

# API App Service Module
module "app_service" {
  source = "./modules/app-service"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  app_service_plan_name = "plan-${var.name}-${var.env}"
  app_service_name      = "app-${var.name}-api-${var.env}"
  sql_server_fqdn       = module.sql_database.sql_server_fqdn
  sql_database_name     = module.sql_database.database_name
  key_vault_uri         = module.key_vault.key_vault_uri
  env                   = var.env
}

# Frontend App Service Module (shares the API App Service Plan)
module "frontend_app_service" {
  source = "./modules/frontend-app-service"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = module.app_service.service_plan_id
  api_base_url        = "https://${module.app_service.default_hostname}"
  environment         = var.env
}

# Key Vault Access Module
module "key_vault_access" {
  source = "./modules/key-vault-access"
  key_vault_id = module.key_vault.key_vault_id
  principal_id = module.app_service.principal_id
}

# Static Web App Module (optional - only if not using App Service for frontend)
module "static_web_app" {
  source = "./modules/static-web-app"
  count  = var.deploy_static_web_app ? 1 : 0
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  static_web_app_name = "stapp-${var.name}-${var.env}"
}
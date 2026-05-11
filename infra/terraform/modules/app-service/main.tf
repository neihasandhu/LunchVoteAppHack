# App Service Module
# Creates App Service Plan and App Service for the .NET 10 API

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
resource "azurerm_service_plan" "main" {
  name                = "${var.app_service_plan_name}-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "main" {
  name                = "app-lunchvote-api-${var.env}-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    ftps_state          = "Disabled"
    http2_enabled       = true
    minimum_tls_version = "1.2"

    application_stack {
      dotnet_version = "8.0"
    }

    cors {
      allowed_origins = compact([
        "http://localhost:5173",
        "http://localhost:3000",
        "https://*.azurestaticapps.net",
        var.frontend_url
      ])
      support_credentials = false
    }
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = var.env == "prod" ? "Production" : "Development"
    "KeyVaultUri"            = var.key_vault_uri
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${var.sql_server_fqdn},1433;Database=${var.sql_database_name};Authentication=Active Directory Default;"
  }
}

# Frontend App Service Module
# Creates App Service for the React/Vite SPA
# Uses the shared App Service Plan created by the API module

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_linux_web_app" "frontend" {
  name                = "app-lunchvote-spa-${var.environment}-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
    http2_enabled       = true
    
    application_stack {
      node_version = "20-lts"
    }

    # Enable SPA routing - all routes should serve index.html
    app_command_line = "pm2 serve /home/site/wwwroot/dist --no-daemon --spa"
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~20"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "VITE_API_BASE_URL" = var.api_base_url
    # Install pm2 globally for serving the SPA
    "PRE_BUILD_COMMAND" = "npm install -g pm2 serve"
  }
}

# Frontend App Service Module
# Creates App Service for the React/Vite SPA
# Uses the shared App Service Plan created by the API module
# SPA build is performed locally and deployed as a pre-built dist/ zip,
# so Oryx build is disabled here.

resource "azurerm_linux_web_app" "frontend" {
  name                = "app-lunchvote-spa-${var.environment}-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on           = false
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
    http2_enabled       = true

    application_stack {
      node_version = "20-lts"
    }

    # Serve pre-built SPA from wwwroot using pm2 + serve (SPA mode rewrites all routes to index.html)
    app_command_line = "pm2 serve /home/site/wwwroot --no-daemon --spa"
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~20"
    # Oryx build disabled: we deploy a pre-built dist/ zip
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "false"
    "ENABLE_ORYX_BUILD"              = "false"
    "VITE_API_BASE_URL"              = var.api_base_url
  }
}

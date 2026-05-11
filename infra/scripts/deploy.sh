#!/bin/bash
set -e

# Configuration
# These are defaults, but Terraform state is the source of truth
LOCATION="australiaeast"

echo "========================================"
echo "  Lunch Vote App - Terraform Deployment "
echo "========================================"

# 1. Run Terraform to apply infrastructure
echo "Step 1: Applying Terraform configuration..."
cd ../terraform
terraform init
terraform apply -auto-approve

# Get Outputs from Terraform
echo "Fetching Terraform outputs..."
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
API_APP_NAME=$(terraform output -raw app_service_name)
SPA_APP_NAME=$(terraform output -raw frontend_app_service_name)
SQL_SERVER=$(terraform output -raw sql_server_fqdn)
API_IDENTITY_ID=$(terraform output -raw app_service_principal_id)

echo "Configuration:"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  API App: $API_APP_NAME"
echo "  SPA App: $SPA_APP_NAME"
echo "  SQL Server: $SQL_SERVER"

# 2. SQL Permissions (Critical Fix)
echo "Step 2: Granting SQL Admin rights to API Managed Identity..."
# Extract just the server name from the FQDN (e.g., sql-server.database.windows.net -> sql-server)
SQL_SERVER_NAME=${SQL_SERVER%%.*}

echo "Setting Active Directory Admin for SQL Server $SQL_SERVER_NAME..."
# Using the CLI to set the admin. This requires the current user to optionally be an admin or have rights.
az sql server ad-admin create \
    --resource-group "$RESOURCE_GROUP" \
    --server-name "$SQL_SERVER_NAME" \
    --display-name "LunchVoteAPI" \
    --object-id "$API_IDENTITY_ID" \
    --output none

echo "SQL Admin permissions granted."

# 3. Build & Deploy API (Self-Contained)
echo "Step 3: Building and Deploying API (Self-Contained Linux x64)..."
cd ../../src/LunchVoteApi

echo "Publishing .NET project..."
dotnet publish -c Release -r linux-x64 --self-contained true -o ./publish

echo "Zipping deployment package..."
cd ./publish
if [ -f api.zip ]; then rm api.zip; fi
zip -r api.zip .

echo "Deploying to Azure App Service: $API_APP_NAME..."
az webapp deploy --resource-group "$RESOURCE_GROUP" \
                 --name "$API_APP_NAME" \
                 --src-path api.zip \
                 --type zip

# 4. Build & Deploy Frontend (Clean Dist)
echo "Step 4: Building and Deploying Frontend..."
cd ../../lunch-vote-spa

echo "Installing dependencies..."
npm install

echo "Building React application..."
npm run build

echo "Zipping dist folder..."
cd dist
if [ -f spa.zip ]; then rm spa.zip; fi
zip -r spa.zip .

echo "Deploying to Azure App Service: $SPA_APP_NAME..."
az webapp deploy --resource-group "$RESOURCE_GROUP" \
                 --name "$SPA_APP_NAME" \
                 --src-path spa.zip \
                 --type zip

# 5. Restart Services
echo "Step 5: Restarting services to ensure configurations take effect..."
az webapp restart --name "$API_APP_NAME" --resource-group "$RESOURCE_GROUP"
az webapp restart --name "$SPA_APP_NAME" --resource-group "$RESOURCE_GROUP"

echo "========================================"
echo "Deployment Complete!"
echo "API URL: https://$API_APP_NAME.azurewebsites.net"
echo "SPA URL: https://$SPA_APP_NAME.azurewebsites.net"
echo "========================================"


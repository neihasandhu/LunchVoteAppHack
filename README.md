# Lunch Vote App

A team-based lunch voting application that enables groups within an organization to democratically decide on lunch options.

## Project Structure

```
LunchVoteApp/
├── .github/
│   └── instructions/          # GitHub Copilot instruction files
│       ├── module_generation_azure.instructions.md
│       └── terraform_coding_standards_azure.instructions.md
├── src/
│   ├── LunchVoteApi/          # .NET 10 Web API
│   └── lunch-vote-spa/        # React + Vite + TypeScript SPA
├── tests/
│   └── LunchVoteApi.Tests/    # Backend unit & integration tests
├── infra/
│   ├── bicep/                 # Azure Bicep IaC templates
│   └── terraform/             # Terraform IaC templates
└── LunchVoteApp.sln           # Visual Studio solution file
```

> **GitHub Copilot Instructions:** The `.github/instructions/` folder contains Terraform coding standards and module generation guidelines. GitHub Copilot automatically follows these instruction files when generating or editing Terraform code in this workspace.

## Technology Stack

### Backend
- .NET 10 Web API
- Entity Framework Core 10
- Azure SQL Database

### Frontend
- React 18+
- Vite 5+
- TypeScript 5+

### Infrastructure
- Azure App Service (Backend API + Frontend SPA)
- Azure SQL Database
- Azure Key Vault

## Prerequisites

- .NET 10 SDK
- Node.js 20+
- Docker (optional, for local SQL Server)
- Azure CLI
- Bicep CLI or Terraform (for infrastructure deployment)

## Environment Setup

### .NET SDK Installation

Check your current .NET version:

```powershell
dotnet --version
```

List installed SDKs:

```powershell
dotnet --list-sdks
```

If you need to install .NET 10.0, use the official installer script:

```powershell
# Download the installer script
Invoke-WebRequest https://dot.net/v1/dotnet-install.ps1 -OutFile dotnet-install.ps1

# Install .NET 10.0
.\dotnet-install.ps1 -Channel 10.0 -InstallDir "$env:USERPROFILE\.dotnet"

# Add to PATH (current session)
$env:PATH="$env:USERPROFILE\.dotnet;$env:PATH"

# Verify installation
dotnet --version
```

### Node.js Installation

To install Node.js v20.11.1 manually on Windows:

```powershell
# Download Node.js
Invoke-WebRequest -Uri "https://nodejs.org/dist/v20.11.1/node-v20.11.1-win-x64.zip" -OutFile "$env:USERPROFILE\Downloads\node.zip"

# Extract to .nodejs folder
Expand-Archive -Path "$env:USERPROFILE\Downloads\node.zip" -DestinationPath "$env:USERPROFILE\.nodejs" -Force

# Move files to parent directory
Move-Item "$env:USERPROFILE\.nodejs\node-v20.11.1-win-x64\*" "$env:USERPROFILE\.nodejs\"

# Add to PATH (current session)
$env:PATH="$env:USERPROFILE\.nodejs;$env:PATH"
```

### Terraform Installation

This project uses **Terraform v1.11.4**.

**Windows Installation:**

Download and install Terraform v1.11.4:

```powershell
# Download Terraform for Windows
Invoke-WebRequest -Uri "https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_windows_amd64.zip" -OutFile "$env:USERPROFILE\Downloads\terraform.zip"

# Extract to a local directory (e.g., C:\terraform)
Expand-Archive -Path "$env:USERPROFILE\Downloads\terraform.zip" -DestinationPath "C:\terraform" -Force

# Add to PATH (current session)
# PowerShell:
$env:PATH="C:\terraform;$env:PATH"

# CMD:
# set PATH=C:\terraform;%PATH%
```

**Other Operating Systems:**

Follow the official installation guide: https://developer.hashicorp.com/terraform/install

**Verify Installation:**

```powershell
terraform -version
```

Expected output: `Terraform v1.11.4`

### Azure CLI

Verify Azure CLI installation:

```powershell
az version
```

### Important Notes

- **Resource Naming**: Terraform resources include a random 6-character suffix to ensure global uniqueness (e.g., `app-lunchvote-api-dev-a1b2c3`).

## Local Development

### Start SQL Server (Docker)

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" \
  -p 1433:1433 --name sql-lunchvote \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

### Start Backend API

```bash
cd src/LunchVoteApi
dotnet run
```

The API will be available at:
- `https://localhost:52544` (HTTPS)
- `http://localhost:52545` (HTTP)

### Start Frontend

```bash
cd src/lunch-vote-spa
npm install
npm run dev
```

The SPA will be available at `http://localhost:5173`

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/polls` | Create a new poll |
| GET | `/api/polls/active?groupId={groupId}` | Get active poll for a group |
| GET | `/api/polls/{pollId}/results` | Get poll results |
| POST | `/api/votes` | Submit a vote |
| GET | `/api/groups` | Get all group IDs with active polls |

## Testing

### Backend Tests

```bash
cd tests/LunchVoteApi.Tests
dotnet test
```

## Deployment

You can deploy the infrastructure using either **Bicep** or **Terraform**.

### Option 1: Deploy with Bicep

#### Deploy Infrastructure

```bash
# Login to Azure
az login

# Get your credentials
az ad signed-in-user show --query id -o tsv          # Object ID
az ad signed-in-user show --query userPrincipalName -o tsv  # Email

# Edit parameters
code infra/bicep/parameters.dev.json

# Create resource group
az group create --name rg-lunchvote-dev --location australiaeast

# Deploy Bicep templates
az deployment group create \
  --resource-group rg-lunchvote-dev \
  --template-file infra/bicep/main.bicep \
  --parameters infra/bicep/parameters.dev.json
```

#### Bicep Resources Created

- Resource Group: `rg-lunchvote-dev`
- Backend App Service Plan: `plan-lunchvote-dev` (Linux, B1 SKU)
- Backend App Service: `app-lunchvote-api-dev` (.NET 10.0)
- Frontend App Service Plan: `plan-lunchvote-spa-dev` (Linux, B1 SKU)
- Frontend App Service: `app-lunchvote-spa-dev` (Node.js 20 LTS)
- SQL Server: `sql-lunchvote-dev` (Entra ID auth only)
- SQL Database: `sqldb-lunchvote` (Basic tier, 2GB)
- Key Vault: `kv-lunchvote-dev` (RBAC enabled)
- Static Web App: `stapp-lunchvote-dev` (optional, disabled by default)

### Option 2: Deploy with Terraform

#### Deploy Infrastructure

```bash
# Login to Azure
az login

# Get your credentials
$OBJECT_ID = az ad signed-in-user show --query id -o tsv
$EMAIL = az ad signed-in-user show --query userPrincipalName -o tsv

# Navigate to terraform directory
cd infra/terraform

# Initialize Terraform
terraform init

# Review the deployment plan
terraform plan -out tfplan -var="sql_admin_object_id=$OBJECT_ID" -var="sql_admin_login=$EMAIL"

# Deploy infrastructure
terraform apply tfplan

# View outputs
terraform output
```

#### Terraform Resources Created

- Resource Group: `rg-lunchvote-dev`
- **Shared** App Service Plan: `plan-lunchvote-dev-{random}` (Linux, **F1 Free** SKU)
- Backend App Service: `app-lunchvote-api-dev-{random}` (.NET 8.0)
- Frontend App Service: `app-lunchvote-spa-dev-{random}` (Node.js 20 LTS) — same plan as API
- SQL Server: `sql-lunchvote-dev-{random}` (Entra ID auth only)
- SQL Database: `sqldb-lunchvote-{random}` (Basic tier, 2GB)
- Key Vault: `kv-lunchvote-dev-{random}` (RBAC enabled)
- Static Web App: `stapp-lunchvote-dev` (optional, disabled by default)

**Note:** The Terraform Azure App Service provider currently supports .NET 8.0 as the runtime. While the application code is built with .NET 10.0, it runs on the .NET 8.0 runtime in Azure. For full .NET 10.0 runtime support, use the Bicep deployment option instead.

#### Terraform Configuration

The deployment uses command-line variables. If you want to customize defaults, you can override them:

```bash
# Optional: Override default values
terraform apply \
  -var="sql_admin_object_id=$OBJECT_ID" \
  -var="sql_admin_login=$EMAIL" \
  -var="environment=dev" \
  -var="location=australiaeast" \
  -var="deploy_static_web_app=false"
```

**Note:** Alternatively, you can create an optional `terraform.tfvars` file (already in .gitignore) with these values to avoid passing them on every command.

### Deploy Backend

The deployment process uses zip deployment to Azure App Service.

<<<<<<< HEAD
**Step 1: Get your App Service name**

The resource name depends on your deployment method:

```bash
# For TERRAFORM deployments - Get the actual name with random suffix
cd infra/terraform
terraform output backend_app_service_name

# OR query Azure directly
az webapp list --resource-group rg-lunchvote-dev --query "[?contains(name, 'api')].name" -o tsv

# For BICEP deployments - The name is fixed
# app-lunchvote-api-dev
```

**Step 2: Build, package, and deploy**

```bash
=======
```powershell
>>>>>>> e4d65c213315add9b6e5c8b240c367e6e6299846
cd src/LunchVoteApi

# Build and publish the application
dotnet publish -c Release -o ./publish

# Remove BuildHost-netcore folder (contains Windows backslash paths that fail on Linux)
Remove-Item -Recurse -Force ./publish/BuildHost-netcore -ErrorAction SilentlyContinue

# Create a zip archive from the published output
Compress-Archive -Path ./publish/* -DestinationPath ./publish.zip -Force

# Deploy the zip archive to Azure App Service
# Replace <app-service-name> with the actual name from Step 1
az webapp deploy \
  --resource-group rg-lunchvote-dev \
<<<<<<< HEAD
  --name <app-service-name> \
=======
  --name app-lunchvote-api-dev-{random-suffix} \
>>>>>>> e4d65c213315add9b6e5c8b240c367e6e6299846
  --src-path ./publish.zip \
  --type zip

# Clean up
Remove-Item ./publish.zip
<<<<<<< HEAD
Remove-Item -Recurse ./publish
```

**Step 3: Verify deployment**

```bash
# Check deployment status
az webapp show \
  --resource-group rg-lunchvote-dev \
  --name <app-service-name> \
  --query "state" -o tsv

# Get the App Service URL
az webapp show \
  --resource-group rg-lunchvote-dev \
  --name <app-service-name> \
  --query "defaultHostName" -o tsv

# Test the API
curl https://<app-service-name>.azurewebsites.net/api/health
=======
Remove-Item -Recurse -Force ./publish
>>>>>>> e4d65c213315add9b6e5c8b240c367e6e6299846
```

**Note:** Replace `{random-suffix}` with the actual suffix from your Terraform deployment output. The `BuildHost-netcore` removal is required when publishing on Windows for a Linux App Service (see Appendix in the Hackathon Guide for details).

### Deploy Frontend

```powershell
cd src/lunch-vote-spa
npm install

# Set the API URL (required - Vite embeds this at build time)
$env:VITE_API_URL = "https://app-lunchvote-api-dev-{random-suffix}.azurewebsites.net/api"
npm run build

# Disable remote build (we're deploying pre-built static files)
az webapp config appsettings set \
  --resource-group rg-lunchvote-dev \
  --name app-lunchvote-spa-dev-{random-suffix} \
  --settings SCM_DO_BUILD_DURING_DEPLOYMENT=false

# Configure pm2 to serve the static SPA with client-side routing
az webapp config set \
  --resource-group rg-lunchvote-dev \
  --name app-lunchvote-spa-dev-{random-suffix} \
  --startup-file "pm2 serve /home/site/wwwroot --no-daemon --spa"

# Zip and deploy
Compress-Archive -Path ./dist/* -DestinationPath ./dist.zip -Force

az webapp deploy \
  --resource-group rg-lunchvote-dev \
  --name app-lunchvote-spa-dev-{random-suffix} \
  --src-path ./dist.zip \
  --type zip

# Clean up
Remove-Item ./dist.zip
```

**Note:** Replace `{random-suffix}` with the actual suffix from your Terraform deployment output.

### Configure CORS (API → Frontend)

After deploying both the API and frontend, configure CORS so the SPA can call the API:

```powershell
# Azure-level CORS
az webapp cors add \
  --resource-group rg-lunchvote-dev \
  --name app-lunchvote-api-dev-{random-suffix} \
  --allowed-origins "https://app-lunchvote-spa-dev-{random-suffix}.azurewebsites.net"

# .NET application-level CORS (AllowedOrigins config array)
az webapp config appsettings set \
  --resource-group rg-lunchvote-dev \
  --name app-lunchvote-api-dev-{random-suffix} \
  --settings \
    AllowedOrigins__0="https://app-lunchvote-spa-dev-{random-suffix}.azurewebsites.net" \
    AllowedOrigins__1="http://localhost:5173" \
    AllowedOrigins__2="http://localhost:3000"

# Restart both apps
az webapp restart --resource-group rg-lunchvote-dev --name app-lunchvote-api-dev-{random-suffix}
az webapp restart --resource-group rg-lunchvote-dev --name app-lunchvote-spa-dev-{random-suffix}
```

> **Why two CORS configurations?** Azure App Service has platform-level CORS that runs before your app code. The .NET API also has its own CORS middleware configured via the `AllowedOrigins` setting in `appsettings.json`. Both must include the frontend origin for cross-origin requests to succeed.

### Create SQL Database User

Terraform automatically configures the `DefaultConnection` connection string on the backend App Service, but the App Service's **Managed Identity** must be manually granted access to the SQL Database. Without this step, the API will return 500 errors when trying to query the database.

1. **Get your App Service name** from Terraform output:

```powershell
cd infra/terraform
terraform output app_service_name
# e.g., app-lunchvote-api-dev-a1b2c3
```

2. **Connect to the SQL Database** using Azure CLI authentication:

```powershell
# Get SQL details from Terraform
$SQL_SERVER = terraform output -raw sql_server_name
$SQL_DB = terraform output -raw sql_database_name

# Open a query editor in the Azure Portal, or use sqlcmd/Azure Data Studio
# You must be connected as the Entra ID admin configured during terraform apply
```

3. **Run the SQL script** (replace `<app-service-name>` with your actual name from step 1):

```sql
CREATE USER [<app-service-name>] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [<app-service-name>];
ALTER ROLE db_datawriter ADD MEMBER [<app-service-name>];
```

A helper script is also available at `infra/scripts/create-sql-user.sql` — update the `@appServiceName` variable with your actual App Service name (including the random suffix).

4. **Restart the API** to apply the connection:

```powershell
az webapp restart --resource-group rg-lunchvote-dev --name <app-service-name>
```

The API will now use Azure SQL Database instead of the in-memory database. EF Core will auto-create the schema tables (`Poll`, `Option`, `Vote`) on startup.

## Infrastructure Features

Both Bicep and Terraform deployments include:

- ✅ **Passwordless Authentication**: SQL Server uses Microsoft Entra ID authentication
- ✅ **Managed Identity**: App Services use System-Assigned Managed Identity
- ✅ **RBAC Authorization**: Key Vault uses role-based access control
- ✅ **Security**: TLS 1.2+, HTTPS-only, soft delete enabled
- ✅ **Environment Isolation**: Resources named with environment suffix (`-dev`, `-stg`, `-prod`)
- ✅ **CORS Configuration**: Pre-configured for local development
- ✅ **Shared App Service Plan**: Single F1 Free plan for both Backend API and Frontend SPA (upgrade to S1 for deployment slots)

## Sample Usage

### Create a Poll

```bash
curl -X POST https://localhost:52544/api/polls \
  -H "Content-Type: application/json" \
  -d '{"groupId":"platform","question":"Where should we eat today?","options":["Sushi","Burgers","Thai","Pizza"]}' \
  -k
```

### Vote

```bash
curl -X POST https://localhost:52544/api/votes \
  -H "Content-Type: application/json" \
  -d '{"pollId":"<poll-id>","optionId":"<option-id>","voterToken":"my-unique-token"}' \
  -k
```

## License

MIT

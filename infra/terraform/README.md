# Terraform Infrastructure

## Structure

```
terraform/
├── main.tf              # Main orchestration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Dev environment values
└── modules/             # Reusable modules
    ├── app-service/           # .NET API App Service
    ├── frontend-app-service/  # React SPA App Service
    ├── sql-database/          # Azure SQL Database
    ├── key-vault/             # Azure Key Vault
    ├── key-vault-access/      # Key Vault access policies
    └── static-web-app/        # Static Web App (optional)
```

## Prerequisites

1. [Terraform 1.11.4](https://www.terraform.io/downloads)
2. [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
3. Azure subscription

## Quick Start

```bash
# 1. Login to Azure
az login

# 2. Navigate to terraform directory
cd infra/terraform

# 3. Initialize Terraform
terraform init

# 4. Review the plan
terraform plan

# 5. Apply the configuration
terraform apply

# 6. View outputs
terraform output
```

## Configuration

Edit `terraform.tfvars` to customize your deployment:

```hcl
env                     = "dev"
location                = "australiaeast"
sql_admin_object_id     = "your-object-id"
sql_admin_login         = "your-email@domain.com"
deploy_static_web_app   = false
```

## Commands

```bash
# Initialize
terraform init

# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan (preview changes)
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy

# Show current state
terraform show

# List outputs
terraform output
```

## Post-Deployment Steps

After the infrastructure is deployed, you'll need to:

### 1. Get the Frontend URL
```bash
terraform output frontend_url
```

### 2. Update API CORS (Optional)
If you want to add the frontend App Service URL to the API's CORS policy:

1. Get the frontend URL from outputs
2. Add it to the API App Service module's `frontend_url` variable in `main.tf`:
   ```hcl
   module "app_service" {
     # ... other parameters ...
     frontend_url = module.frontend_app_service.url
   }
   ```
3. Run `terraform apply` again

Alternatively, you can manually add the CORS origin in the Azure Portal:
- Navigate to API App Service → CORS
- Add the frontend URL to allowed origins

### 3. Deploy Applications

**Deploy API:**
```bash
cd ../../src/LunchVoteApi
dotnet publish -c Release
cd bin/Release/net8.0/publish
zip -r deploy.zip .
az webapp deployment source config-zip --resource-group rg-lunchvote-dev --name <api-app-name> --src deploy.zip
```

**Deploy Frontend:**
```bash
cd ../../src/lunch-vote-spa
npm install
npm run build
cd dist
zip -r deploy.zip .
az webapp deployment source config-zip --resource-group rg-lunchvote-dev --name <frontend-app-name> --src deploy.zip
```


## Module Dependencies

The modules are deployed in the following order:
1. SQL Database
2. Key Vault
3. API App Service (depends on SQL and Key Vault)
4. Frontend App Service (gets API URL from API App Service)
5. Key Vault Access (depends on Key Vault and App Services)
6. Static Web App (optional, alternative to Frontend App Service)

## Architecture

This Terraform configuration deploys a **dual App Service architecture**:

- **API App Service**: 
  - Linux App Service with .NET 8.0 runtime
  - Connected to Azure SQL Database via managed identity
  - Accesses Key Vault for secrets
  - CORS configured for local development and frontend app
  
- **Frontend App Service**:
  - Linux App Service with Node.js 20 LTS runtime
  - Hosts React/Vite SPA
  - Configured with API base URL as environment variable
  - Build happens during deployment (npm install + vite build)

## Notes

- All resources use passwordless authentication with Microsoft Entra ID
- Key Vault uses RBAC authorization (not access policies)
- Static Web App is optional and controlled by `deploy_static_web_app` variable
- Both app services use unique names with random suffixes to avoid naming conflicts
- Frontend app service gets the API URL automatically from the API App Service deployment

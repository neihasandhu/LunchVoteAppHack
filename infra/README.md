# Infrastructure as Code

This directory contains all Infrastructure as Code (IaC) for the LunchVoteApp project.

## Structure

```
infra/
├── README.md          # This file
├── terraform/         # Terraform IaC
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   └── modules/
└── bicep/             # Bicep IaC
    ├── main.bicep
    ├── parameters.dev.json
    └── modules/
```

## Quick Start

### Terraform
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

### Bicep
```bash
cd bicep
# Edit parameters.dev.json with your values
az deployment group create \
  --resource-group rg-lunchvote-dev \
  --template-file main.bicep \
  --parameters parameters.dev.json
```

## Choosing Between Terraform and Bicep

- **Terraform**: Use if you need multi-cloud support or prefer HCL syntax
- **Bicep**: Use if you're Azure-only and want native ARM integration

Both implement the same infrastructure.

## Frontend Deployment

### Manual Deployment Steps

The SPA is deployed as a static site hosted on an Azure Web App (Node.js runtime).
Follow these steps to deploy manually, ensuring the build artifacts are correctly packaged
and the App Service is configured to bypass the default Oryx build process.

1. **Build the application**:
   \\\ash
   cd src/lunch-vote-spa
   npm install
   npm run build
   \\\

2. **Package the artifact**:
   Compress the \dist\ folder into a zip file. Ensure the zip contains the \dist\ folder at the root, not just its contents.

   Powershell:
   \\\powershell
   Compress-Archive -Path dist -DestinationPath dist.zip -Force
   \\\

3. **Configure App Service**:
   Ensure the following settings are configured on your Azure Web App to bypass Oryx build and use the pre-built artifacts:

   \\\ash
   # Disable build during deployment
   az webapp config appsettings set --resource-group <resource-group-name> --name <app-name> --settings SCM_DO_BUILD_DURING_DEPLOYMENT=false ENABLE_ORYX_BUILD=false

   # Set startup command to serve the dist folder
   # Startup command: pm2 serve /home/site/wwwroot/dist --no-daemon --spa
   \\\

4. **Deploy**:
   Use \config-zip\ to deploy the artifact:
   \\\ash
   az webapp deployment source config-zip --resource-group <resource-group-name> --name <app-name> --src ./dist.zip
   \\\


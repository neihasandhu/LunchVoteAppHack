# Challenge 3: ☁️ Liftoff! Deploy to the Cloud

### *"Ground control to Major Tom  your app is going live on Azure"*

**Duration:** ~60 minutes

[⬅ Back to Hackathon Participant Guide](../HACKATHON_PARTICIPANT_GUIDE.md)

---

### Synopsis

You've built the blueprint (Terraform) and the interface (React SPA). Now it's time for the most exciting moment  watching your creation come alive in the cloud. In this challenge, you'll provision your Azure infrastructure using Terraform and deploy both the backend API and frontend SPA to **Azure App Service**.

### What You'll Learn

#### Terraform Plan & Apply Workflow
Terraform follows a deliberate, two-step deployment process:
1. **`terraform plan`**  Shows you exactly what resources will be created, modified, or destroyed *before* making any changes. This is your safety net.
2. **`terraform apply`**  Executes the plan and provisions the actual cloud resources.

This plan-then-apply workflow prevents accidental changes and gives you full visibility into what's happening in your cloud environment.

#### Azure App Service Deployment
**Zip deployment** is one of the simplest and most reliable ways to deploy to Azure App Service. You package your application into a `.zip` file and push it to Azure using the CLI. Azure handles the rest  extracting the archive, configuring the runtime, and starting your app.

For the **.NET API**, you'll:
1. Publish the app (`dotnet publish`) to create a self-contained deployment package
2. Zip the published output
3. Deploy using `az webapp deploy --type zip`

For the **React SPA**, you'll:
1. Build the production bundle (`npm run build`)  
2. Zip the `dist/` output
3. Deploy to the frontend App Service

#### CORS (Cross-Origin Resource Sharing)
When your frontend (running on one domain) makes API calls to your backend (on a different domain), the browser blocks these requests by default for security. **CORS** configuration on the backend explicitly allows your frontend's domain to make cross-origin requests. After deployment, you'll need to update CORS settings so your Azure-hosted frontend can talk to your Azure-hosted backend.

### Your Mission

Provision your Terraform infrastructure to Azure and deploy both the API and SPA to their respective App Services.

### 🤖 GitHub Copilot Skill Focus: `@terminal` Participant + Inline Terminal Chat

This challenge is all about command-line work - and Copilot shines here too!

#### `@terminal` - Your Command-Line Guide

Instead of Googling Azure CLI syntax, ask Copilot directly in chat:
- `@terminal How do I deploy a zip file to Azure App Service?`
- `@terminal What's the command to list all resources in my resource group?`
- `@terminal Explain what az webapp deploy --type zip does`

#### Inline Chat in the Terminal

Press `Ctrl+I` while your cursor is in the **integrated terminal** to open Inline Chat. Describe what you want in natural language - Copilot generates the command:
- *"Publish my .NET app to a folder called publish"*  → `dotnet publish -c Release -o ./publish`
- *"Zip all files in the publish folder"* → `Compress-Archive -Path ./publish/* -DestinationPath ./publish.zip -Force`
- *"Show me the terraform outputs"* → `terraform output`

#### Error Troubleshooting

When a command fails:
1. Select the error text in the terminal
2. Right-click → **Copilot: Explain This**
3. Or use `@terminal /explain` with the error message in chat

> 💡 **Pro Tip:** After a failed command, you can click the sparkle icon ✨ next to the terminal error to have Copilot suggest a fix automatically.

#### 🔧 Azure Copilot — Your Cloud Debugging Companion in the Azure Portal

**[Azure Copilot](https://learn.microsoft.com/en-us/azure/copilot/overview)** is an AI assistant built into the **Azure Portal** that helps you design, operate, optimise, and troubleshoot your Azure resources using natural language. It's available at no additional cost — just click the **Copilot icon** in the portal header to open it. From this challenge onward, it's an invaluable companion alongside GitHub Copilot in VS Code.

**Key capabilities relevant to this hackathon:**

- **Troubleshoot App Service deployments** — *"Why did my App Service deployment fail?"* or *"What's the issue with my app?"* — Azure Copilot analyses diagnostics and suggests fixes ([learn more](https://learn.microsoft.com/en-us/azure/copilot/troubleshoot-app-service))
- **Query resource information** — *"Show me resources in rg-lunchvote-dev"* — uses Azure Resource Graph queries to surface resource status, health, and configuration ([learn more](https://learn.microsoft.com/en-us/azure/copilot/get-information-resource-graph))
- **Monitor and debug** — *"Show me monitoring metrics for my App Service"* — view request counts, response times, and error rates without navigating between blades ([learn more](https://learn.microsoft.com/en-us/azure/copilot/get-monitoring-information))
- **Generate CLI and Terraform scripts** — *"Generate an Azure CLI command to update CORS on my App Service"* — Azure Copilot can author runnable scripts for common operations ([learn more](https://learn.microsoft.com/en-us/azure/copilot/generate-cli-scripts))
- **Get Advisor recommendations** — *"Show me cost optimisation recommendations"* — surfaces Well-Architected Framework guidance tailored to your deployed resources

> 💡 **Tip:** You can add context to your Azure Copilot conversation by selecting specific resources, subscriptions, or resource groups — this helps it give more targeted answers. Try it after running `terraform apply` by asking: *"Troubleshoot my App Service"* and selecting the deployed App Service resource.

### Acceptance Criteria

| # | Criteria | Details |
|---|----------|---------|
| ✅ 1 | **Azure login** | Successfully authenticated with Azure CLI (`az login`) |
| ✅ 2 | **Terraform init** | `terraform init` completes successfully in your Terraform directory |
| ✅ 3 | **Terraform plan** | `terraform plan` shows the expected resources to be created (Resource Group, 2x App Service Plans, 2x App Services, SQL Server, SQL Database, Key Vault, Role Assignment) |
| ✅ 4 | **Terraform apply** | `terraform apply` completes successfully and all resources are provisioned in Azure |
| ✅ 5 | **Terraform outputs** | `terraform output` displays the API URL, Frontend URL, SQL Server FQDN, and other configured outputs |
| ✅ 6 | **Backend deployed** | The .NET API is published (`dotnet publish -c Release`), zipped, and deployed to the API App Service using `az webapp deploy`. Swagger UI is accessible at the deployed URL |
| ✅ 7 | **Frontend deployed** | The React SPA is built (`npm run build`), zipped, and deployed to the Frontend App Service. The home page loads at the Frontend URL |
| ✅ 8 | **CORS updated** | The backend API's CORS settings include the Frontend App Service URL so the SPA can make API calls |
| ✅ 9 | **End-to-end works** | You can open the deployed Frontend URL in a browser, see the home page, navigate to a group, and see poll data (from the in-memory database) |
| ✅ 10 | **GitHub Copilot** | Used GitHub Copilot to assist with deployment commands, troubleshoot errors, or understand Azure CLI syntax |


### Prerequisites: Set Up Terraform Backend Storage

Terraform stores its state in an Azure Storage account. Before running `terraform init`, you need to create this backend infrastructure:

```powershell
# 1. Create resource group for Terraform state (Australia East region)
az group create --name rg-terraform-state --location australiaeast

# 2. Create storage account for state files
az storage account create `
  --name sttfstatelunchvote `
  --resource-group rg-terraform-state `
  --location australiaeast `
  --sku Standard_LRS

# 3. Create blob container to hold the state file
az storage container create `
  --name tfstate `
  --account-name sttfstatelunchvote
```

> **Note:** This is a one-time setup. The backend configuration in `versions.tf` references these resources:
> - Resource Group: `rg-terraform-state`
> - Storage Account: `sttfstatelunchvote`
> - Container: `tfstate`
> - State File: `lunchvote-dev.tfstate`

> 💡 **Why?** Storing Terraform state remotely enables team collaboration, state locking to prevent conflicts, and keeps sensitive data out of version control.

### Deployment Commands Cheat Sheet

> 💡 Use GitHub Copilot to help you fill in the blanks and troubleshoot any issues.

```powershell
# 1. Get your Azure credentials
$OBJECT_ID = az ad signed-in-user show --query id -o tsv
$EMAIL = az ad signed-in-user show --query userPrincipalName -o tsv

# 2. Provision infrastructure (after completing backend setup above)
cd infra/my-terraform
terraform init  # Will now connect to the remote backend in Azure
terraform plan -out tfplan -var="sql_admin_object_id=$OBJECT_ID" -var="sql_admin_login=$EMAIL"
terraform apply tfplan

# 3. Get the deployed resource names
terraform output

# 4. Deploy the backend API
cd ../../src/LunchVoteApi
dotnet publish -c Release -o ./publish
Compress-Archive -Path ./publish/* -DestinationPath ./publish.zip -Force
az webapp deploy --resource-group <RG_NAME> --name <API_APP_NAME> --src-path ./publish.zip --type zip
Remove-Item ./publish.zip

# 5. Build & deploy the frontend
cd ../lunch-vote-spa
npm run build
Compress-Archive -Path ./dist/* -DestinationPath ./dist.zip -Force
az webapp deploy --resource-group <RG_NAME> --name <SPA_APP_NAME> --src-path ./dist.zip --type zip
Remove-Item ./dist.zip
```

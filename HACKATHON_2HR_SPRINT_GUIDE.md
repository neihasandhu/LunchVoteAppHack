# Lunch Vote App — Sprint Hackathon (10:30 AM – 1:00 PM)

## **"Zero to Cloud Hero — Speed Run Edition"**

### For experienced developers who know Azure, Terraform, and React

---

## Overview

This is a condensed version of the [full-day hackathon](HACKATHON_PARTICIPANT_GUIDE.md), designed for **advanced users** who can complete it in **2 hours**. The last 30 minutes are flexible for stretch goals, demos, or voting on lunch with your app. 🍕

**What you're building:** A team-based **Lunch Vote App** — provision Azure infrastructure with Terraform, deploy a full-stack app, wire up Azure SQL with passwordless auth, secure secrets with Key Vault, and implement blue/green deployments.

**What's different from the full-day version:**
- Frontend SPA is **pre-built** — skip Challenge 2 entirely
- SQL Database + Key Vault are **merged** into one sprint
- Explanatory sections removed — you know what Terraform, RBAC, and Managed Identity are
- Copilot tutorials trimmed — use it however you prefer
- Private networking is a **stretch goal**, not required

---

## 📋 Agenda

| Time | Sprint | Title | Duration |
|------|--------|-------|----------|
| 10:30 – 10:40 | — | **Setup Verification** | 10 min |
| 10:40 – 11:10 | Sprint 1 | 🏗️ Terraform IaC | 30 min |
| 11:10 – 11:35 | Sprint 2 | ☁️ Deploy to Azure | 25 min |
| 11:35 – 12:05 | Sprint 3 | 🗃️🔐 SQL + Key Vault | 30 min |
| 12:05 – 12:30 | Sprint 4 | 🚢 Blue/Green Deployment | 25 min |
| | | | |
| 12:30 – 1:00 | — | **🎯 Flex Time** *(see below)* | 30 min |

---

## 🛠️ Prerequisites (Verify Before Starting)

We are using **GitHub Codespaces** to ensure everyone has a consistent, ready-to-go environment. A tailored `devcontainer.json` is already provided which includes all the prerequisite tools (Node 20, .NET 8, Terraform, Azure CLI) pre-installed!

1. **Launch your Codespace:**
   - Log in to GitHub using your already created **GitHubAlias**.
   - Navigate to the repository on GitHub.
   - Click the green **Code** button.
   - Select the **Codespaces** tab.
   - Click **Create codespace on main**.

2. **Authenticate to Azure (using your provided Hackathon Account):**
   You have been provided a `copilotuser` account configured with a Temporary Access Pass (TAP). Use this to log in to Azure:

   ```bash
   az login --use-device-code  # Follow prompts using your copilotuser account + TAP
   ```

3. **Verify the API works locally:**
   ```bash
   cd src/LunchVoteApi
   dotnet run
   # The port will be forwarded securely by Codespaces.
   # Visit the forwarded URL and append /swagger to explore the API.
   # Test: curl -k https://localhost:52544/api/groups
   ```

---

## 📚 API Quick Reference

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/polls` | Create a new poll |
| `GET` | `/api/polls/active?groupId={groupId}` | Get active poll for a group |
| `GET` | `/api/polls/{pollId}/results` | Get poll results |
| `POST` | `/api/votes` | Submit a vote |
| `GET` | `/api/groups` | Get all group IDs with active polls |

<details>
<summary><strong>Request/Response Bodies</strong></summary>

**CreatePollRequest:**
```json
{ "groupId": "platform", "question": "Where should we eat?", "options": ["Sushi", "Burgers", "Thai", "Pizza"] }
```

**VoteRequest:**
```json
{ "pollId": "<guid>", "optionId": "<guid>", "voterToken": "unique-browser-token" }
```

**PollResults:**
```json
{ "pollId": "<guid>", "question": "string", "results": [{ "optionId": "<guid>", "text": "string", "count": 0 }], "totalVotes": 0 }
```
</details>

---

## Sprint 1: 🏗️ Terraform IaC (30 min)

> **Goal:** Author Terraform code with Copilot to provision all Azure resources.

⚠️ **Delete or rename `infra/terraform/`** so Copilot doesn't just copy the reference implementation. Write your own in `infra/my-terraform/`.

### Structure

```
infra/my-terraform/
├── main.tf           # Provider, resource group, module calls
├── variables.tf      # Input variables with validation
├── outputs.tf        # Resource names, URLs, FQDNs
└── modules/
    ├── app-service/          # Backend API: App Service Plan + App Service
    ├── frontend-app-service/ # Frontend SPA: App Service (shared plan)
    ├── sql-database/         # SQL Server + Database
    ├── key-vault/            # Key Vault
    └── key-vault-access/     # RBAC role assignment
```

### Acceptance Criteria

| # | Criteria |
|---|----------|
| 1 | `azurerm` provider ~> 4.0 configured |
| 2 | Resource Group: `rg-lunchvote-{environment}` |
| 3 | Backend App Service: Linux, .NET 8.0, SystemAssigned identity, HTTPS-only, TLS 1.2+, CORS for `http://localhost:5173` |
| 4 | Frontend App Service: Linux, Node.js 20, SystemAssigned identity, HTTPS-only, TLS 1.2+ |
| 5 | SQL Server: Entra ID auth only (no SQL password), Basic tier DB, Azure services firewall rule |
| 6 | Key Vault: RBAC authorization, standard SKU, soft delete |
| 7 | RBAC: Backend identity gets "Key Vault Secrets User" role |
| 8 | SQL connection string on backend App Service using `Active Directory Default` |
| 9 | Variables: `environment` (validated: dev/stg/prod), `location`, `sql_admin_object_id`, `sql_admin_login` |
| 10 | Outputs: API name/hostname/URL, Frontend name/hostname/URL, SQL FQDN, DB name |
| 11 | `terraform init` and `terraform validate` pass |

### 💡 Speed Tips

- Use Copilot Agent mode (`Ctrl+Shift+I`) — let it create all files and fix validation errors autonomously
- Prompt: *"Create a complete modular Terraform configuration for a .NET web app with React frontend, Azure SQL, and Key Vault. Use azurerm ~> 4.0, managed identity, RBAC, HTTPS-only, and Entra ID auth for SQL."*
- Run `terraform validate` after each module — fix errors before moving on

---

## Sprint 2: ☁️ Deploy to Azure (25 min)

> **Goal:** Provision infrastructure and deploy both API + SPA to Azure App Service.

### Step 1: Terraform Backend + Apply

```powershell
# One-time: create state storage
az group create --name rg-terraform-state --location australiaeast
az storage account create --name sttfstatelunchvote --resource-group rg-terraform-state --location australiaeast --sku Standard_LRS
az storage container create --name tfstate --account-name sttfstatelunchvote

# Get your credentials
$OBJECT_ID = az ad signed-in-user show --query id -o tsv
$EMAIL = az ad signed-in-user show --query userPrincipalName -o tsv

# Provision
cd infra/my-terraform
terraform init
terraform plan -out tfplan -var="sql_admin_object_id=$OBJECT_ID" -var="sql_admin_login=$EMAIL"
terraform apply tfplan
terraform output
```

### Step 2: Deploy Backend API

```powershell
cd ../../src/LunchVoteApi
dotnet publish -c Release -o ./publish
Remove-Item -Recurse -Force ./publish/BuildHost-netcore -ErrorAction SilentlyContinue
Compress-Archive -Path ./publish/* -DestinationPath ./publish.zip -Force
az webapp deploy --resource-group <RG> --name <API_APP_NAME> --src-path ./publish.zip --type zip
Remove-Item ./publish -Recurse -Force; Remove-Item ./publish.zip
```

> ⚠️ If the API targets .NET 10 but Terraform set .NET 8: `az webapp config set --resource-group <RG> --name <API_APP_NAME> --linux-fx-version "DOTNETCORE|10.0"`

### Step 3: Deploy Frontend SPA

```powershell
cd ../lunch-vote-spa
npm install && npm run build
Compress-Archive -Path ./dist/* -DestinationPath ./dist.zip -Force
az webapp deploy --resource-group <RG> --name <SPA_APP_NAME> --src-path ./dist.zip --type zip
Remove-Item ./dist.zip
```

### Step 4: Update CORS

```powershell
az webapp cors add --resource-group <RG> --name <API_APP_NAME> --allowed-origins "https://<SPA_APP_NAME>.azurewebsites.net"
```

### Acceptance Criteria

| # | Criteria |
|---|----------|
| 1 | `terraform apply` completes — all resources visible in Azure Portal |
| 2 | Backend API deployed — Swagger UI accessible at deployed URL |
| 3 | Frontend SPA deployed — home page loads |
| 4 | CORS configured — SPA can call API |
| 5 | End-to-end works — create poll, vote, see results via deployed frontend |

> 💡 For initial testing, remove the SQL connection string so the API uses in-memory data:
> `az webapp config connection-string delete --resource-group <RG> --name <API_APP_NAME> --setting-names DefaultConnection`

---

## Sprint 3: 🗃️🔐 SQL Database + Key Vault (30 min)

> **Goal:** Wire up Azure SQL with passwordless auth via Managed Identity, then secure the connection string in Key Vault.

### Part A: Connect to Azure SQL

**1. Verify the SQL connection string** (Terraform should have set this):

```powershell
az webapp config connection-string list --resource-group <RG> --name <API_APP_NAME> -o table
# Should show: DefaultConnection = Server=tcp:<server>.database.windows.net,1433;Database=<db>;Authentication=Active Directory Default;
```

**2. Create the SQL user for the App Service's Managed Identity:**

```powershell
# Get your access token
$TOKEN = az account get-access-token --resource https://database.windows.net --query accessToken -o tsv
```

Connect to the database (SSMS, Azure Data Studio, or sqlcmd) and run:

```sql
CREATE USER [<api-app-service-name>] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [<api-app-service-name>];
ALTER ROLE db_datawriter ADD MEMBER [<api-app-service-name>];
```

**3. Verify persistence:** Restart the App Service, create a poll, restart again, confirm data survives.

```powershell
az webapp restart --resource-group <RG> --name <API_APP_NAME>
```

### Part B: Secure Secrets in Key Vault

**1. Store the connection string in Key Vault:**

```powershell
$CONN_STR = "Server=tcp:<server>.database.windows.net,1433;Database=<db>;Authentication=Active Directory Default;"
az keyvault secret set --vault-name <VAULT_NAME> --name "DefaultConnection" --value "$CONN_STR"
```

**2. Grant yourself Key Vault Secrets Officer:**

```powershell
az role assignment create --role "Key Vault Secrets Officer" --assignee <YOUR_EMAIL> `
  --scope /subscriptions/<SUB_ID>/resourceGroups/<RG>/providers/Microsoft.KeyVault/vaults/<VAULT_NAME>
```

**3. Set the Key Vault URI on the App Service:**

```powershell
az webapp config appsettings set --resource-group <RG> --name <API_APP_NAME> `
  --settings KeyVaultUri="https://<VAULT_NAME>.vault.azure.net/"
```

**4. Verify:** No plaintext secrets in app settings or code. App reads from Key Vault via Managed Identity.

### Acceptance Criteria

| # | Criteria |
|---|----------|
| 1 | SQL Server visible in Portal with Entra ID admin configured |
| 2 | Firewall rule allows Azure services (`0.0.0.0`) |
| 3 | `DefaultConnection` set with `Active Directory Default` |
| 4 | SQL user created for App Service Managed Identity with `db_datareader` + `db_datawriter` |
| 5 | Data persists across App Service restarts |
| 6 | Connection string stored in Key Vault |
| 7 | App Service has "Key Vault Secrets User" RBAC role (via Terraform) |
| 8 | `KeyVaultUri` app setting configured |
| 9 | No plaintext secrets anywhere |

---

## Sprint 4: 🚢 Blue/Green Deployment (25 min)

> **Goal:** Upgrade to S1, create a staging slot, deploy to staging, swap to production with zero downtime.

### Step 1: Upgrade App Service Plan

```powershell
# Free tier doesn't support slots — upgrade to Standard S1
az appservice plan update --name <PLAN_NAME> --resource-group <RG> --sku S1
```

### Step 2: Create Staging Slot

```powershell
az webapp deployment slot create --name <API_APP_NAME> --resource-group <RG> --slot staging
```

### Step 3: Deploy to Staging

```powershell
cd src/LunchVoteApi
dotnet publish -c Release -o ./publish
Remove-Item -Recurse -Force ./publish/BuildHost-netcore -ErrorAction SilentlyContinue
Compress-Archive -Path ./publish/* -DestinationPath ./publish.zip -Force
az webapp deploy --name <API_APP_NAME> --resource-group <RG> --slot staging --src-path ./publish.zip --type zip
Remove-Item ./publish -Recurse -Force; Remove-Item ./publish.zip
```

### Step 4: Verify Staging

```powershell
# Staging has its own URL
az webapp browse --name <API_APP_NAME> --resource-group <RG> --slot staging
# Check: https://<API_APP_NAME>-staging.azurewebsites.net/swagger
```

### Step 5: Swap & Rollback

```powershell
# Swap staging → production (zero downtime)
az webapp deployment slot swap --name <API_APP_NAME> --resource-group <RG> --slot staging --target-slot production

# Verify production is running the new version
# To rollback — just swap again:
az webapp deployment slot swap --name <API_APP_NAME> --resource-group <RG> --slot staging --target-slot production
```

### Step 6: Live Logs

```powershell
az webapp log tail --name <API_APP_NAME> --resource-group <RG>
```

### Acceptance Criteria

| # | Criteria |
|---|----------|
| 1 | App Service Plan upgraded to S1 |
| 2 | Staging slot exists with its own URL |
| 3 | New version deployed to staging slot |
| 4 | Staging verified independently |
| 5 | Slot swap performed — production updated with zero downtime |
| 6 | Rollback demonstrated via second swap |
| 7 | Live log streaming shown via `az webapp log tail` |

### 🏋️ Stretch Goal: Private Networking

If you finish early, add VNet integration + Private Endpoint for SQL:

- Create VNet (`10.0.0.0/16`) with two subnets: `snet-appservice-integration` (`10.0.1.0/24`) and `snet-private-endpoints` (`10.0.2.0/24`)
- Enable App Service VNet integration via the integration subnet
- Create a Private Endpoint for SQL Server in the PE subnet
- Add Private DNS Zone `privatelink.database.windows.net`, link to VNet
- Disable public access on SQL Server: `public_network_access_enabled = false`

---

## 🎯 Flex Time: 12:30 – 1:00 PM

Use this time however works best for you:

- **Catch up** — finish any incomplete sprints
- **Stretch goals** — try Private Networking (see Sprint 4) or build the frontend from scratch (see [Challenge 2](challenges/challenge-2.md))
- **Explore** — dig into Azure Portal, review Terraform state, inspect Key Vault audit logs
- **Demo prep** — get your environment ready to show off
- **Vote on lunch!** — use your deployed app to decide where to eat 🍕

### Demo Checklist

| # | Item | Status |
|---|------|--------|
| 1 | Terraform code authored with Copilot | ⬜ |
| 2 | Infrastructure provisioned — resources visible in Azure Portal | ⬜ |
| 3 | Backend API deployed and responding | ⬜ |
| 4 | Frontend SPA deployed and accessible | ⬜ |
| 5 | SQL Database connected with Managed Identity (no passwords) | ⬜ |
| 6 | Data persists across App Service restarts | ⬜ |
| 7 | Key Vault configured with Managed Identity access | ⬜ |
| 8 | Blue/Green deployment with slot swap demonstrated | ⬜ |
| 9 | Live log streaming shown | ⬜ |

> 🍕 **Now use your app to vote on where to eat lunch!**

---

## 🧹 Cleanup (After Lunch)

```powershell
az group delete --name rg-lunchvote-dev --yes --no-wait
az group delete --name rg-terraform-state --yes --no-wait
```

---

## Appendix: Common Issues

<details>
<summary><strong>.NET Runtime Mismatch</strong></summary>

Terraform may set .NET 8.0 but the API targets .NET 10:
```powershell
az webapp config set --resource-group <RG> --name <API_APP_NAME> --linux-fx-version "DOTNETCORE|10.0"
az webapp restart --resource-group <RG> --name <API_APP_NAME>
```
</details>

<details>
<summary><strong>Zip Deploy Fails (BuildHost-netcore)</strong></summary>

Windows publish output includes backslash paths that fail on Linux:
```powershell
Remove-Item -Recurse -Force ./publish/BuildHost-netcore -ErrorAction SilentlyContinue
```
</details>

<details>
<summary><strong>API Returns 500 After Deploy</strong></summary>

SQL Managed Identity user likely not created yet. Quick fix — remove the connection string to use in-memory DB:
```powershell
az webapp config connection-string delete --resource-group <RG> --name <API_APP_NAME> --setting-names DefaultConnection
az webapp restart --resource-group <RG> --name <API_APP_NAME>
```
</details>

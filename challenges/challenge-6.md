# Challenge 6: 🚢 Ship It Like a Pro

### *"Production-grade deployment isn't just shipping code  it's shipping confidence"*

**Duration:** ~60 minutes

[⬅ Back to Hackathon Participant Guide](../HACKATHON_PARTICIPANT_GUIDE.md)

---

### Synopsis

Your app is deployed, secured, and connected to a real database. But is it production-ready? Not yet. Real-world applications need **zero-downtime deployments**, **rollback capabilities**, **deployment verification** before going live, _and_ **private network connectivity** so that data never travels over the public internet. In this final challenge, you'll level up your deployment game on two fronts:

1. **Blue/Green Deployment** — Azure App Service Deployment Slots for instant, zero-downtime releases with rollback.
2. **Private Network Security** — VNet integration and Private Endpoints so the API reaches the database exclusively over a private network, and Azure SQL's public endpoint is switched off.

### What You'll Learn

#### Blue/Green Deployment
**Blue/Green Deployment** is a release strategy that eliminates downtime and reduces risk:

- **Blue** = the current production version (live traffic)
- **Green** = the new version you're about to release (staging)

The process:
1. Deploy the new version to the **staging slot** (green)
2. Test and verify the staging slot independently
3. **Swap** the staging and production slots  this is nearly instant (typically < 1 second)
4. If something goes wrong, swap back  instant rollback!

The swap operation works by changing the routing rules, not moving files, making it extraordinarily fast.

#### Azure App Service Deployment Slots
**Deployment Slots** are live App Service instances with their own hostnames. The **Standard (S1)** tier or above supports slots. Key features:

- **Isolated environments**  Staging slot has its own URL, app settings, and connection strings
- **Warm-up**  Azure warms up the staging slot before swapping, preventing cold-start issues
- **Auto-swap**  Optionally auto-swap to production after deploying to staging
- **Traffic routing**  Gradually route a percentage of traffic to the new version (canary deployments)
- **Slot-specific settings**  Some settings can be "sticky" to a slot (e.g., different database for staging vs production)

> ⚠️ **Important: Free (F1) Tier Does Not Support Deployment Slots**
>
> The Terraform templates deploy the App Service Plan on the **F1 Free** tier (a single shared plan for both the API and SPA). The Free tier **does not** support deployment slots. You **must** upgrade to at least **Standard S1** before you can create a staging slot.
>
> **Upgrade via Azure CLI (recommended for this challenge):**
> ```powershell
> # Get the plan name from Terraform output
> cd infra/terraform
> $PLAN_NAME = terraform output -raw service_plan_name
>
> # Upgrade to Standard S1
> az appservice plan update --name $PLAN_NAME --resource-group rg-lunchvote-dev --sku S1
> ```
>
> Alternatively, update the `sku_name` in your Terraform `app-service` module from `"F1"` to `"S1"` and run `terraform apply`.

#### App Service Scaling & Monitoring
Beyond deployment, you'll explore:
- **Application logging**  View real-time logs from your App Service using `az webapp log tail`
- **Health checks**  Configure App Service health checks to automatically replace unhealthy instances
- **App Service metrics**  View request count, response time, and error rates in the Azure Portal

---

#### Private Connectivity & Network Security

By default, the Azure SQL server accepts connections from any IP address on the public internet (guarded only by credentials). For a production system this is unacceptable. The solution is a **hub-and-spoke networking pattern**:

```
 Internet
    │  (blocked — public access disabled on SQL)
    ▼
 ┌──────────────────────────────────────────────┐
 │  Virtual Network  10.0.0.0/16                │
 │                                              │
 │  snet-appservice-integration  10.0.1.0/24   │
 │        ▲  (delegated to Web/serverFarms)     │
 │        │  App Service VNet Integration       │
 │        │                                     │
 │  ┌─────┴────────────────────────────────┐   │
 │  │           API App Service             │   │
 │  └───────────────────────┬───────────────┘   │
 │                           │ outbound via VNet │
 │  snet-private-endpoints  10.0.2.0/24         │
 │        ▼                                     │
 │  ┌───────────────────────────────────────┐   │
 │  │  Private Endpoint NIC  (private IP)   │   │
 │  └───────────────────────┬───────────────┘   │
 │                           │                   │
 │  Private DNS Zone                            │
 │  privatelink.database.windows.net            │
 │  → sql-lunchvote-dev.database.windows.net    │
 │    resolves to 10.0.2.x  (private IP)        │
 └──────────────────────────────────────────────┘
                           │
                     Azure SQL Server
```

**Key concepts you'll implement:**

| Concept | What it does |
|---|---|
| **Virtual Network (VNet)** | Private address space – `10.0.0.0/16`. All resources in the same VNet can communicate over private IPs. |
| **App Service VNet Integration** | Connects outbound traffic from the App Service into the VNet, so it leaves through a private NIC rather than the public internet. Requires integration subnet delegated to `Microsoft.Web/serverFarms`. |
| **Private Endpoint** | Provisions a private NIC inside the VNet with a private IP mapped to the Azure SQL server. Clients resolve the SQL FQDN to this private IP through the private DNS zone. |
| **Private DNS Zone** | `privatelink.database.windows.net` — overrides public DNS inside the VNet so the SQL server FQDN resolves to the private IP, not the public one. |
| **Disable Public Access** | Sets `public_network_access_enabled = false` on the SQL server so all connections **must** come through the private endpoint — no exceptions. |

### Your Mission

Upgrade your App Service Plan from Free (F1) to Standard (S1), create a staging deployment slot, implement a blue/green deployment workflow, and demonstrate zero-downtime releases.

### 🤖 GitHub Copilot Skill Focus: Code Review + Commit Message Generation

For the final challenge, you'll use Copilot as a **code reviewer** and **DevOps assistant** - the capstone of your Copilot journey.

#### AI-Powered Code Review

Before committing your Terraform changes for deployment slots:

1. Open the **Source Control** view (`Ctrl+Shift+G`)
2. Click the **Code Review** button (sparkle icon) to review all uncommitted changes
3. Copilot will add inline review comments highlighting potential issues, security concerns, and improvement suggestions
4. Alternatively, select a block of changed code → right-click → **Generate Code** → **Review**

#### Smart Commit Messages

Instead of writing vague commit messages like "updated stuff":
1. Stage your changes in Source Control
2. Click the **sparkle icon ✨** next to the commit message input box
3. Copilot analyzes your diff and generates a descriptive commit message like: *"feat: add staging deployment slot with warm-up config and S1 SKU upgrade"*

#### Using `#changes` in Chat

Reference your current uncommitted changes in chat:
- *"#changes Review my Terraform changes for the deployment slot and suggest any security improvements"*
- *"#changes Summarize what I changed and help me write release notes"*

#### Quick Chat for DevOps Questions

Use **Quick Chat** (`Ctrl+Shift+Alt+L`) for fast questions without leaving your current workflow:
- *"What's the difference between slot swap and slot swap with preview?"*
- *"How does App Service warm-up work during a slot swap?"*

### Acceptance Criteria

| # | Criteria | Details |
|---|----------|---------|
| ✅ 1 | **Tier upgraded** | The shared App Service Plan (used by both API and SPA) is upgraded from **F1 Free** to at least **Standard S1** tier. Use Azure CLI: `az appservice plan update --name <PLAN_NAME> --resource-group <RG> --sku S1`, or update the `sku_name` in Terraform and apply |
| ✅ 2 | **Staging slot created** | A deployment slot named `staging` exists on the backend API App Service |
| ✅ 3 | **Deploy to staging** | Deploy a new version of the API to the **staging** slot (not production). The staging slot should have its own URL (e.g., `https://app-lunchvote-api-dev-xxx-staging.azurewebsites.net`) |
| ✅ 4 | **Verify staging** | Access the staging slot's Swagger UI or API endpoint and confirm it's running correctly |
| ✅ 5 | **Swap slots** | Perform a slot swap between staging and production. Verify that the production URL now serves the new version |
| ✅ 6 | **Zero downtime** | Demonstrate that the swap did not cause any downtime  the production URL remained accessible throughout the swap |
| ✅ 7 | **Rollback capability** | Perform another swap to roll back to the previous version. Verify the rollback works |
| ✅ 8 | **Live log streaming** | Use `az webapp log tail` to stream live logs from the production App Service and demonstrate you can see real-time request/response activity |
| ✅ 9 | **Terraform updated** | Your Terraform code is updated to include the staging slot configuration and the upgraded SKU |
| ✅ 10 | **GitHub Copilot** | Used GitHub Copilot to help with slot management commands, Terraform slot configuration, or understanding deployment slot concepts |
| ✅ 11 | **VNet created** | A Virtual Network named `vnet-lunchvote-dev` (or similar) exists in `rg-lunchvote-dev` with two subnets: `snet-appservice-integration-dev` (`10.0.1.0/24`) and `snet-private-endpoints-dev` (`10.0.2.0/24`) |
| ✅ 12 | **VNet integration enabled** | The API App Service is integrated with the VNet via the `snet-appservice-integration-dev` subnet. Verify with `az webapp vnet-integration list` |
| ✅ 13 | **Private endpoint deployed** | A private endpoint for the SQL server exists in `snet-private-endpoints-dev`. The NIC has a private IP in the `10.0.2.0/24` range. Verify with `az network private-endpoint list` |
| ✅ 14 | **Private DNS zone linked** | `privatelink.database.windows.net` DNS zone exists and is linked to the VNet. Inside the VNet the SQL FQDN resolves to a private IP (not the public one). Verify with `nslookup <sql-fqdn>` from the App Service console |
| ✅ 15 | **Public access disabled** | The SQL server has `public_network_access_enabled = false`. Confirm with `az sql server show --query publicNetworkAccess` — should return `Disabled` |

### Useful Commands

> 💡 Use GitHub Copilot to help construct and troubleshoot these commands.

```powershell
# Get the App Service Plan name from Terraform output
cd infra/terraform
$PLAN_NAME = terraform output -raw service_plan_name

# Upgrade App Service Plan to Standard S1 (required for deployment slots)
az appservice plan update --name $PLAN_NAME --resource-group <RG> --sku S1

# Create a staging deployment slot
az webapp deployment slot create --name <APP_NAME> --resource-group <RG> --slot staging

# Deploy to the staging slot
az webapp deploy --name <APP_NAME> --resource-group <RG> --slot staging --src-path ./publish.zip --type zip

# Browse the staging slot
az webapp browse --name <APP_NAME> --resource-group <RG> --slot staging

# Swap staging to production
az webapp deployment slot swap --name <APP_NAME> --resource-group <RG> --slot staging --target-slot production

# Rollback (swap again)
az webapp deployment slot swap --name <APP_NAME> --resource-group <RG> --slot staging --target-slot production

# Stream live logs
az webapp log tail --name <APP_NAME> --resource-group <RG>

# View deployment slot list
az webapp deployment slot list --name <APP_NAME> --resource-group <RG> -o table

# ---------------------------------------------------------------------------
# Private Connectivity Verification
# ---------------------------------------------------------------------------

# List private endpoints in the resource group
az network private-endpoint list --resource-group rg-lunchvote-dev -o table

# Show the private IP assigned to the SQL private endpoint NIC
$PE_NAME = az network private-endpoint list --resource-group rg-lunchvote-dev --query "[?contains(name, 'sql')].name" -o tsv
az network private-endpoint show --name $PE_NAME --resource-group rg-lunchvote-dev --query "customDnsConfigs[0].ipAddresses" -o tsv

# Verify App Service VNet integration
az webapp vnet-integration list --name <APP_NAME> --resource-group rg-lunchvote-dev -o table

# Verify SQL public access is disabled
az sql server show --name <SQL_SERVER_NAME> --resource-group rg-lunchvote-dev --query publicNetworkAccess -o tsv

# Verify DNS resolution from App Service (run in Kudu console or SSH)
# Portal -> App Service -> SSH -> run:
#   nslookup <sql-server-name>.database.windows.net
# Private IP (10.0.2.x) = private endpoint is working
# Public IP = private endpoint is NOT routing correctly

# Verify private DNS zone exists and is linked to VNet
az network private-dns zone list --resource-group rg-lunchvote-dev -o table
az network private-dns link vnet list --resource-group rg-lunchvote-dev --zone-name privatelink.database.windows.net -o table

# Enable private networking via Terraform (set in terraform.tfvars)
# enable_private_networking = true
# Then run:
cd infra/terraform
terraform plan -var="enable_private_networking=true"
terraform apply -var="enable_private_networking=true"
```

### Terraform Hint for Deployment Slots

Ask GitHub Copilot to help you add this to your App Service module:

```hcl
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.main.id
  # ... configure same settings as production
}
```

### Terraform Hints for Private Networking

Ask GitHub Copilot to help you understand these resources:

```hcl
# 1. Virtual Network and subnets (modules/private-networking/main.tf)
resource "azurerm_virtual_network" "main" {
  name          = "vnet-${var.name}-${var.env}"
  address_space = ["10.0.0.0/16"]
  # ...
}

# Delegation required for App Service VNet integration
resource "azurerm_subnet" "app_service_integration" {
  delegation {
    service_delegation { name = "Microsoft.Web/serverFarms" }
  }
}

# 2. Private Endpoint for SQL (modules/sql-database/main.tf)
resource "azurerm_private_endpoint" "sql" {
  count     = var.enable_private_endpoint ? 1 : 0
  subnet_id = var.private_endpoint_subnet_id

  private_service_connection {
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

# 3. App Service VNet Integration (modules/app-service/main.tf)
resource "azurerm_linux_web_app" "main" {
  virtual_network_subnet_id = var.vnet_integration_subnet_id != "" ? var.vnet_integration_subnet_id : null
  # ...
}

# 4. To enable it all, set in terraform.tfvars:
enable_private_networking = true
```

> ⚠️ **SKU requirement:** App Service VNet Integration requires **Basic (B1) or higher**. Upgrade from F1 → S1 as part of Acceptance Criteria #1 before enabling private networking.

---

### 🌟 Beyond the Hackathon — Making It Production-Ready

Congratulations on completing the challenges! You've built, deployed, secured, and scaled a real cloud application. But in a true enterprise environment, there's more to consider before going to production. These aren't part of today's hackathon, but they're worth knowing about as you take your Azure skills forward.

#### Observability & Monitoring

- **Azure Application Insights** — Add the Application Insights SDK to your .NET API for automatic collection of request traces, dependency calls (SQL queries, HTTP calls), exceptions, and custom metrics. This gives you end-to-end distributed tracing across your frontend and backend. [→ Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/app/asp-net-core)
- **Azure Monitor Alerts** — Set up alert rules that notify your team when response times exceed thresholds, error rates spike, or your App Service becomes unhealthy. Alerts can trigger emails, SMS, Azure Functions, or Logic Apps. [→ Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)
- **Log Analytics Workspace** — Centralise all your logs (App Service, SQL Database, Key Vault audit logs) into a single Log Analytics workspace and query them with **KQL (Kusto Query Language)**. This is essential for incident investigation and compliance. [→ Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview)
- **Azure Dashboard & Workbooks** — Create custom dashboards in the Azure Portal that show real-time metrics, availability, and SLO tracking for your application at a glance. [→ Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview)

#### Security Hardening

- **Microsoft Defender for Cloud** — Enable Defender for App Service and Defender for SQL to get continuous security assessments, vulnerability scanning, and threat detection. It flags misconfigurations (e.g., TLS version, HTTPS enforcement) and alerts on suspicious activity like SQL injection attempts. [→ Learn more](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction)
- **Azure DDoS Protection** — For internet-facing applications, Azure DDoS Protection provides always-on traffic monitoring and automatic attack mitigation at the network edge. [→ Learn more](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview)
- **Managed Certificates & Custom Domains** — App Service provides free managed TLS certificates for custom domains, automatically renewing them. No more expired certificates in production. [→ Learn more](https://learn.microsoft.com/en-us/azure/app-service/configure-ssl-certificate)

#### Reliability & Disaster Recovery

- **Autoscaling** — Configure rule-based or metric-based autoscaling on your App Service Plan to handle traffic spikes without manual intervention. Scale out to multiple instances and back down during quiet periods. [→ Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/autoscale/autoscale-overview)
- **Azure SQL Geo-Replication** — Replicate your database to a secondary Azure region for disaster recovery. If your primary region goes down, you can failover to the secondary within minutes. [→ Learn more](https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-overview)
- **Azure Backup** — Enable automated backups for your App Service and configure long-term retention policies for your SQL Database to meet compliance requirements.
- **Health Checks** — Configure App Service health check endpoints so Azure automatically detects and replaces unhealthy instances without manual intervention. [→ Learn more](https://learn.microsoft.com/en-us/azure/app-service/monitor-instances-health-check)

#### CI/CD & Governance

- **GitHub Actions** — Automate your entire deployment pipeline: run tests, build artifacts, deploy to the staging slot, run smoke tests, and swap to production — all triggered by a pull request merge. [→ Learn more](https://learn.microsoft.com/en-us/azure/app-service/deploy-github-actions)
- **Azure Policy** — Enforce organisational standards across all Azure resources (e.g., "all storage accounts must use HTTPS", "all SQL servers must have Entra-only authentication"). Non-compliant resources are flagged or blocked automatically. [→ Learn more](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
- **Resource Locks** — Prevent accidental deletion of critical resources (like your SQL Database or Key Vault) by applying `CanNotDelete` locks. [→ Learn more](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)

> 💡 **Tip:** Ask Azure Copilot in the Azure Portal: *"What security recommendations do you have for my resource group rg-lunchvote-dev?"* — it will surface actionable Advisor recommendations across all your deployed resources.

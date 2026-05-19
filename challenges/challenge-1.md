# Challenge 1: 🏗️ The Architect's Blueprint

### *"Every skyscraper starts with a blueprint  yours is written in Terraform"*

**Duration:** ~60 minutes

[⬅ Back to Hackathon Participant Guide](../HACKATHON_PARTICIPANT_GUIDE.md)

---

### ⚠️ Before You Begin — Workspace Preparation

This repository contains a **complete Terraform configuration** in `infra/terraform/` that was used to provision the reference environment. If this folder remains in your workspace, GitHub Copilot will use it as context and may simply reproduce the existing code rather than helping you learn to write your own.

Choose one of these paths before you start:

- **Write Terraform from scratch:** move `infra/terraform/` outside the workspace and build your own configuration in `infra/my-terraform/`.
- **Use the provided templates:** keep `infra/terraform/` in the workspace and treat it as your baseline. You can deploy it directly or copy it into `infra/my-terraform/` before modifying it.


---

### Synopsis

Before a single line of application code runs in the cloud, someone needs to build the cloud itself. In this challenge, you will become that someone. Using **Terraform** and **GitHub Copilot**, you'll define the complete Azure infrastructure for the Lunch Vote App as code  a practice known as **Infrastructure as Code (IaC)**.

### What You'll Learn

#### Terraform & Infrastructure as Code (IaC)
Terraform is an open-source tool by HashiCorp that lets you define cloud infrastructure using a declarative configuration language called **HCL (HashiCorp Configuration Language)**. Instead of clicking through the Azure Portal to create resources, you write `.tf` files that describe *what* you want, and Terraform figures out *how* to create it. This approach gives you:

- **Repeatability**: Deploy the same infrastructure across dev, staging, and production environments
- **Version Control**: Track infrastructure changes alongside your application code in Git
- **Collaboration**: Review infrastructure changes through pull requests
- **Drift Detection**: Terraform can detect when infrastructure has been manually modified

#### Azure Resource Group
A **Resource Group** is a logical container in Azure that holds related resources. Think of it as a folder for your cloud resources. All resources in this hackathon will live in a single resource group, making it easy to manage, monitor costs, and clean up when done. Resource groups also define the **region** (geographic location) where metadata is stored.

#### Azure App Service & App Service Plans
**Azure App Service** is a fully managed platform for building, deploying, and scaling web apps. An **App Service Plan** defines the compute resources (CPU, memory, pricing tier) that your App Service runs on.

Key benefits:
- **Zero infrastructure management**  no VMs to patch or maintain
- **Built-in autoscaling**  handle traffic spikes automatically
- **Deployment slots**  enable blue/green deployments (you'll explore this in Challenge 6!)
- **Managed Identity support**  passwordless authentication to other Azure services

You'll create **two** App Service Plans and **two** App Services: one for the backend API (.NET 10) and one for the frontend SPA (Node.js 20).

#### Azure SQL Database
A fully managed relational database service. You'll configure it with **Microsoft Entra ID authentication only** (no SQL passwords!), which is a modern security best practice.

#### Azure Key Vault
A cloud service for securely storing secrets, keys, and certificates. Your app will use it to store sensitive configuration like connection strings. You'll configure it with **RBAC (Role-Based Access Control)** authorization.

### Your Mission

Using GitHub Copilot in VS Code, provision the Lunch Vote App's Azure infrastructure by either authoring Terraform from scratch or adapting the provided templates.

> ⚠️ **Important:** Choose one learning path and stay intentional about it.
> - If you pick the scratch path, write your own Terraform with GitHub Copilot and keep the reference templates out of the workspace.
> - If you pick the template path, use `infra/terraform/` as a starting point and focus on understanding, validating, and customizing the modules rather than copying blindly.

### Terraform Structure to Create

```
infra/
└── my-terraform/
    ├── main.tf              # Main orchestration, provider config, resource group
    ├── variables.tf         # Input variables
    ├── outputs.tf           # Output values
    └── modules/
        ├── app-service/     # Backend API App Service + Plan
        ├── frontend-app-service/  # Frontend SPA App Service + Plan
        ├── sql-database/    # Azure SQL Server + Database
        ├── key-vault/       # Azure Key Vault
        └── key-vault-access/  # RBAC role assignment for Key Vault
```

If you choose the template path, this structure already exists under `infra/terraform/`.

### Acceptance Criteria

| # | Criteria | Details |
|---|----------|---------|
| ✅ 1 | **Provider configuration** | Terraform `azurerm` provider ~> 4.0 is configured with required features block |
| ✅ 2 | **Resource Group** | An Azure Resource Group is created with naming convention `rg-lunchvote-{environment}` |
| ✅ 3 | **Backend App Service** | A shared Linux App Service Plan (F1 Free SKU) and App Service with .NET 8.0 runtime, `SystemAssigned` managed identity, HTTPS-only, TLS 1.2+, and CORS configured for `http://localhost:5173` |
| ✅ 4 | **Frontend App Service** | A Linux App Service (sharing the backend plan) with Node.js 20 LTS runtime, `SystemAssigned` managed identity, HTTPS-only, TLS 1.2+ |
| ✅ 5 | **SQL Server & Database** | Azure SQL Server with **Entra ID authentication only** (no SQL password), a database named `sqldb-lunchvote-{random}` with Basic tier and 2GB max size, and a firewall rule allowing Azure services |
| ✅ 6 | **Key Vault** | Azure Key Vault with RBAC authorization enabled, standard SKU, and soft delete |
| ✅ 7 | **Key Vault Access** | An `azurerm_role_assignment` granting the backend App Service's managed identity the **"Key Vault Secrets User"** role |
| ✅ 8 | **Connection String** | The backend App Service has a SQL connection string configured using `Active Directory Default` authentication |
| ✅ 9 | **Variables** | Input variables defined for: `environment` (with validation for dev/stg/prod), `location`, `sql_admin_object_id`, `sql_admin_login`, and `deploy_static_web_app` |
| ✅ 10 | **Outputs** | Outputs defined for: API App Service name/hostname/URL, Frontend App Service name/hostname/URL, SQL Server FQDN, SQL Database name |
| ✅ 11 | **Validation** | `terraform init` and `terraform validate` pass without errors |
| ✅ 12 | **GitHub Copilot** | Demonstrate that GitHub Copilot assisted in writing the Terraform code (show chat history or inline suggestions) |

### 🤖 GitHub Copilot Skill Focus: Agent Mode + Custom Agents

This challenge introduces **Agent mode** and **Custom Agents** - the most powerful way to use Copilot for code generation.

#### Step-by-Step: Create a Terraform Custom Agent

1. In VS Code, open the Chat view (`Ctrl+Alt+I`)
2. Click the agent dropdown (top of Chat) → **Configure Custom Agents** → **Create new custom agent**
3. Choose **Workspace** and name it `terraform-architect`
4. Paste this into your `.github/agents/terraform-architect.agent.md`:

```markdown
---
description: Azure Terraform infrastructure specialist
tools: ['editFiles', 'runInTerminal', 'codebase', 'fetch', 'search']
---

You are an expert Terraform engineer specializing in Azure cloud infrastructure.

## Rules
- Always use modular Terraform structure with separate modules per resource type
- Use azurerm provider ~> 4.0
- Include variable validation rules for environment (dev/stg/prod)
- Enable managed identity (SystemAssigned) on all App Services
- Use RBAC authorization for Key Vault (never access policies)
- Configure HTTPS-only, TLS 1.2+, and FTPS disabled on all web apps
- Include meaningful outputs for all resource names, hostnames, and URLs
- Add random suffixes to globally unique resource names
```

5. Switch to your **terraform-architect** agent from the dropdown
6. Now ask: *"Create a Terraform module for an Azure Linux App Service with managed identity and .NET 8 runtime"*

> Notice how the custom agent gives more targeted, consistent results than a generic prompt!

#### Additional Copilot Techniques

- **Agent mode (`Ctrl+Shift+I`)**: Let Copilot create files, run `terraform validate`, and fix issues autonomously
- **Ask mode**: Switch to **Ask** agent to learn: *"Explain the difference between azurerm_role_assignment and azurerm_key_vault_access_policy"*
- **Inline suggestions**: Open a `.tf` file and start typing `resource "azurerm_` - watch Copilot auto-complete the resource block
- **`@terminal`**: In chat, ask `@terminal how do I initialize Terraform in my infra directory?`
- **`/explain`**: Select a Terraform block and use `/explain` to understand what it does

# Challenge 5: 🔐 The Vault of Secrets

### *"In the cloud, secrets should never be out in the open"*

**Duration:** ~60 minutes

[⬅ Back to Hackathon Participant Guide](../HACKATHON_PARTICIPANT_GUIDE.md)

---

### Synopsis

In the previous challenge, you connected your application to Azure SQL Database and set a connection string directly in App Service settings. It works — but there's a problem. That connection string and any other sensitive configuration values are sitting in **plain text** in app settings, visible to anyone with access to the Azure Portal or CLI. In the real world, this is a security risk.

Enter **Azure Key Vault** and **Managed Identity** — two Azure services that work together to give your application **passwordless, secure access** to sensitive configuration. In this challenge, you'll move your SQL connection string (and any other secrets) into Key Vault, configure your App Service to read them securely using its **Managed Identity**, and ensure zero plaintext secrets remain in your deployment.

### What You'll Learn

#### Azure Key Vault
**Azure Key Vault** is a cloud service for securely storing and tightly controlling access to:
- **Secrets**  Connection strings, API keys, passwords
- **Keys**  Encryption keys for data protection
- **Certificates**  SSL/TLS certificates

Key benefits:
- **Centralized secret management**  One place to manage all secrets
- **Access auditing**  Full audit log of who accessed what and when
- **Soft delete & purge protection**  Accidentally deleted secrets can be recovered
- **HSM-backed**  Hardware Security Module protection for encryption keys

#### Azure Managed Identity
**Managed Identity** is Azure's answer to the "how do I authenticate without storing passwords?" problem. When you enable a **System-Assigned Managed Identity** on an App Service, Azure automatically:

1. Creates an identity (service principal) in Microsoft Entra ID
2. Manages the credentials (no passwords for you to rotate!)
3. Lets your app authenticate to other Azure services using that identity

This eliminates the "chicken-and-egg" problem: *"I need a secret to access the secrets store."* With Managed Identity, your app authenticates using its Azure-managed identity  no secrets required.

#### RBAC (Role-Based Access Control)
Instead of legacy access policies, modern Key Vault uses **RBAC** to control who can do what. Common roles:
- **Key Vault Secrets User**  Can read secret values (what your App Service needs)
- **Key Vault Secrets Officer**  Can read, write, and delete secrets (for administrators)
- **Key Vault Administrator**  Full management access

### Your Mission

Configure your deployed Azure infrastructure so the backend App Service can securely access secrets from Key Vault using its Managed Identity  with zero passwords in your codebase.

### 🤖 GitHub Copilot Skill Focus: Ask Agent + `/explain` for Deep Learning

Security concepts like Managed Identity, RBAC, and Key Vault can be complex. This challenge is designed for **learning** - and the **Ask** agent is your teacher.

#### Using Ask Agent to Learn

Switch to the **Ask** agent from the dropdown (it never modifies files - safe for exploration):

- *"Explain how Azure Managed Identity works at a technical level. How does the token exchange happen?"*
- *"What's the difference between System-Assigned and User-Assigned Managed Identity?"*
- *"Why is RBAC preferred over Key Vault access policies?"*
- *"What happens when my App Service tries to access Key Vault - walk me through the authentication flow"*

#### `/explain` on Terraform Code

Select your Key Vault Terraform module and use `/explain` to understand each property:
- What does `enable_rbac_authorization = true` do?
- What is `soft_delete_retention_days` and why does it matter?
- What does the `role_definition_name = "Key Vault Secrets User"` role allow?

#### Multi-Model Exploration

Try asking the same question to **different AI models** using the model picker (click the model name at the bottom of chat). Compare how Claude, GPT, and other models explain Managed Identity differently - you'll get richer understanding from multiple perspectives!

### Acceptance Criteria

| # | Criteria | Details |
|---|----------|---------|
| ✅ 1 | **Key Vault exists** | Your Terraform-deployed Key Vault is visible in the Azure Portal with RBAC authorization enabled |
| ✅ 2 | **Managed Identity enabled** | The backend App Service has a System-Assigned Managed Identity with a valid Principal ID |
| ✅ 3 | **RBAC role assigned** | The App Service's Managed Identity has been granted the **"Key Vault Secrets User"** role on the Key Vault (via your Terraform `azurerm_role_assignment` or Azure CLI) |
| ✅ 4 | **Secret stored** | The SQL connection string from Challenge 4 is stored as a secret in Key Vault. You can do this via Azure Portal or Azure CLI |
| ✅ 5 | **App setting configured** | The backend App Service has a `KeyVaultUri` app setting pointing to the Key Vault URI (e.g., `https://kv-lunchvote-dev.vault.azure.net/`) |
| ✅ 6 | **No plaintext secrets** | Verify that no connection strings, passwords, or API keys are stored as plaintext in app settings, code, or configuration files in your repository |
| ✅ 7 | **Key Vault accessible** | Demonstrate the App Service can access Key Vault  either by reading the secret through application code or by verifying via Application Logs that Key Vault connectivity succeeds |
| ✅ 8 | **Your own access** | Grant your own Azure user at least the **"Key Vault Secrets Officer"** role so you can manage secrets via the Portal or CLI |
| ✅ 9 | **Audit trail** | Show the Key Vault audit/activity log in the Azure Portal demonstrating access events |
| ✅ 10 | **GitHub Copilot** | Used GitHub Copilot to help with Azure CLI commands for secret management, RBAC assignments, or understanding Managed Identity concepts |

### Useful Azure CLI Commands

> 💡 Ask GitHub Copilot to help you construct these commands with your specific resource names.

```powershell
# Store a secret in Key Vault
az keyvault secret set --vault-name <VAULT_NAME> --name "TestSecret" --value "HelloFromVault"

# Read a secret from Key Vault
az keyvault secret show --vault-name <VAULT_NAME> --name "TestSecret" --query value -o tsv

# List all secrets
az keyvault secret list --vault-name <VAULT_NAME> -o table

# Assign yourself Key Vault Secrets Officer role
az role assignment create --role "Key Vault Secrets Officer" \
  --assignee <YOUR_EMAIL> \
  --scope /subscriptions/<SUB_ID>/resourceGroups/<RG>/providers/Microsoft.KeyVault/vaults/<VAULT_NAME>

# Check the App Service's Managed Identity principal ID
az webapp identity show --name <APP_NAME> --resource-group <RG> --query principalId -o tsv
```

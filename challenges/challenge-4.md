# Challenge 4: 🗃️ The Data Fortress

### *"From in-memory whispers to a fortress of persistent data"*

**Duration:** ~60 minutes

[⬅ Back to Hackathon Participant Guide](../HACKATHON_PARTICIPANT_GUIDE.md)

---

### Synopsis

Right now, your application is running on an **in-memory database**  every time the App Service restarts, all polls and votes vanish like they never existed. That's fine for development, but production apps need **persistent, reliable data storage**. In this challenge, you'll connect your Lunch Vote App to **Azure SQL Database**  a fully managed relational database in the cloud  using **passwordless authentication** via Managed Identity.

### What You'll Learn

#### Azure SQL Database
**Azure SQL Database** is a fully managed relational database engine based on Microsoft SQL Server. Key advantages:

- **Fully managed**  Azure handles patching, backups, high availability, and disaster recovery
- **Scalable**  Scale compute and storage independently, from Basic tier (5 DTUs) to Business Critical
- **Built-in intelligence**  Automatic performance tuning, threat detection, and vulnerability assessments
- **Geo-replication**  Replicate data across Azure regions for disaster recovery
- **Familiar T-SQL**  Use the same SQL you already know from SQL Server

#### Microsoft Entra ID Authentication for SQL
Traditional SQL Server uses username/password authentication. Modern Azure SQL supports **Microsoft Entra ID (formerly Azure AD) authentication**, which offers:

- **Passwordless access**  Applications authenticate using Managed Identity tokens
- **Centralized identity**  All access controlled through your organization's directory
- **Conditional access**  Apply policies like MFA requirements
- **Auditable**  See exactly who accessed the database and when

In this challenge, you'll configure SQL Server with **Entra ID authentication only**  fully eliminating SQL passwords from your architecture.

#### Entity Framework Core Migrations
**Entity Framework Core (EF Core)** is .NET's ORM (Object-Relational Mapper) that maps C# classes to database tables. The application uses EF Core with the `EnsureCreated()` approach  it automatically creates the database schema on first connection. When connected to Azure SQL, this will create the `Poll`, `Option`, and `Vote` tables automatically.

#### Connection Strings with Active Directory Default
The connection string uses `Authentication=Active Directory Default`, which tells the SQL client to authenticate using the app's Managed Identity when running in Azure, or your Azure CLI credentials when running locally. No password needed!

```
Server=tcp:<server>.database.windows.net,1433;Database=<database-name>;Authentication=Active Directory Default;
```

> **Note:** Both `<server>` and `<database-name>` include a random 6-character suffix added by Terraform (e.g., `sql-lunchvote-dev-a1b2c3` and `sqldb-lunchvote-a1b2c3`). Run `terraform output` to get the actual values.

### Your Mission

Wire up your deployed backend API to the Azure SQL Database provisioned by Terraform, using Managed Identity for passwordless authentication.

### 🤖 GitHub Copilot Skill Focus: Custom Instructions + `#codebase` Context

This challenge introduces **Custom Instructions** - always-on rules that shape every Copilot response in your workspace.

#### Step-by-Step: Create Custom Instructions

1. Create the file `.github/copilot-instructions.md` in your workspace root
2. Add rules that apply globally to all Copilot interactions:

```markdown
## Project Context
This is the Lunch Vote App - a team-based lunch voting application.
- Backend: .NET 10 Web API with Entity Framework Core
- Frontend: React + TypeScript SPA with Vite
- Database: Azure SQL Database with Entra ID authentication
- Infrastructure: Terraform with modular structure

## Coding Standards
- Always use `Authentication=Active Directory Default` for SQL connections (never SQL auth)
- Use System-Assigned Managed Identity for all Azure service-to-service auth
- Never hardcode secrets, connection strings, or passwords in code
- Use RBAC instead of access policies for Key Vault
- All Terraform resources should follow naming convention: {type}-lunchvote-{environment}
```

Now every Copilot response will respect these rules automatically!

#### Using `#codebase` for Project-Aware Responses

When asking Copilot about database connectivity, use `#codebase` to give it full project context:

- *"#codebase How is the database connection configured in this project? What connection string format does it use?"*
- *"#codebase Show me how EF Core is configured and what entities exist"*
- *"#codebase What changes would I need to make to switch from in-memory to Azure SQL?"*

The `#codebase` keyword triggers a semantic search across your entire workspace, giving Copilot rich understanding of your project's patterns.

### Acceptance Criteria

| # | Criteria | Details |
|---|----------|---------|
| ✅ 1 | **SQL Server accessible** | The Azure SQL Server created by Terraform is visible in the Azure Portal with Entra ID admin configured |
| ✅ 2 | **Firewall configured** | Azure SQL has a firewall rule allowing Azure services (IP range `0.0.0.0 – 0.0.0.0`) and optionally your client IP for management |
| ✅ 3 | **Connection string set** | The backend App Service has a connection string named `DefaultConnection` with format: `Server=tcp:<server>.database.windows.net,1433;Database=<database-name>;Authentication=Active Directory Default;` (Terraform sets this automatically — use `terraform output` to get actual names) |
| ✅ 4 | **SQL user created** | The App Service's Managed Identity is added as a user in the SQL Database with `db_datareader` and `db_datawriter` roles |
| ✅ 5 | **Schema created** | The database tables (`Poll`, `Option`, `Vote`) exist in Azure SQL (auto-created by EF Core's `EnsureCreated()` on application startup when `ASPNETCORE_ENVIRONMENT=Development`) |
| ✅ 6 | **Persistent data** | Create a poll via the deployed API, restart the App Service, and verify the poll data persists |
| ✅ 7 | **No SQL passwords** | The entire data access chain uses Managed Identity  no SQL usernames or passwords anywhere |
| ✅ 8 | **End-to-end test** | Using the deployed Frontend SPA: create a poll, cast votes from multiple browsers/tabs, and view results. Data persists across App Service restarts |
| ✅ 9 | **GitHub Copilot** | Used GitHub Copilot to help with SQL commands, connection string formats, or troubleshooting database connectivity |

### Creating the SQL Database User

After the App Service's Managed Identity is enabled, you need to grant it access to the SQL Database. Connect to your database using Azure CLI authentication and run:

```sql
-- Replace <app-service-name> with your actual API App Service name
CREATE USER [<app-service-name>] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [<app-service-name>];
ALTER ROLE db_datawriter ADD MEMBER [<app-service-name>];
```

> 💡 Ask GitHub Copilot: *"How do I connect to Azure SQL Database using Azure CLI authentication and run a SQL script?"*

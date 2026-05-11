# Lunch Vote App  One-Day Hackathon Participant Guide

## **"From Zero to Cloud Hero"**

### Build, Deploy & Scale a Real-World Cloud Application with Azure and GitHub Copilot

---

## Welcome, Hackers! 👋

Today, you'll go from a blank canvas to a fully operational, cloud-native application running on **Microsoft Azure**  and you'll do it with an AI-powered co-pilot at your side. By the end of this hackathon, you'll have hands-on experience with Infrastructure as Code, modern frontend development, cloud deployment patterns, security best practices, and more.

**What you're building:** A team-based **Lunch Vote App**  a real-time polling application where teams in your organization can vote on where to eat lunch. Think of it as democracy for your stomach. 🍕🍔🍜🌮

**What's provided:** A fully functional **.NET 10 REST API** (backend) with Swagger documentation and an in-memory database for local development. Your job is to build everything else around it.

**The twist:** You'll be using **GitHub Copilot** as your AI pair-programmer throughout every challenge. Learning to prompt effectively, iterate with Copilot, and leverage AI-assisted development is a core skill you'll sharpen today.

---

## GitHub Copilot Deep Dive - Your AI Toolkit

Before we begin, let's understand the **GitHub Copilot features** you'll be mastering today. Each challenge deliberately introduces a different Copilot capability so that by the end of the day, you'll be a Copilot power user.

### Built-in Agents (Chat Personas)

GitHub Copilot in VS Code offers three built-in **agents** - each optimized for different workflows. You select an agent from the dropdown at the top of the Chat view:

| Agent | Shortcut | What It Does | When to Use It |
|-------|----------|--------------|----------------|
| **Agent** | `Ctrl+Shift+I` | Autonomously plans, edits files, runs terminal commands, and invokes tools across your workspace | Building features, fixing bugs, scaffolding projects |
| **Plan** | `/plan` | Creates a structured, step-by-step implementation plan *without* writing code. Hands off to Agent when approved | Complex tasks, architecture decisions, before major changes |
| **Ask** | `Ctrl+Alt+I` | Answers questions about coding concepts, your codebase, or VS Code itself. Read-only - never modifies files | Learning, exploration, understanding unfamiliar code |

> 💡 **Pro Tip:** Start with **Plan** to think through your approach, then hand off to **Agent** to implement it. This mirrors real-world software engineering: *design first, code second*.

### Reusable Prompt Files

One of the most powerful (and underused) Copilot features is **Prompt Files** (`.prompt.md`) — reusable, shareable prompt templates stored in your repository:

- **What:** Markdown files with a `.prompt.md` extension stored in `.github/prompts/`
- **Why:** Instead of typing the same long prompt repeatedly, encode it once and invoke it by name in chat
- **How:** They use a YAML frontmatter with a `description` field, followed by a Markdown body containing the prompt instructions
- **Bonus:** You can reference workspace files, use variables like `${selection}`, and share them with your team via Git

**Example — `build-api.prompt.md`:**
```markdown
---
name: build-api
description: Build and run the backend API
---

Restore NuGet dependencies, compile, and run the .NET backend API
located in src/LunchVoteApi/.
Report any build errors with suggested fixes.
```

You invoke it in chat by typing its name — and Copilot executes the prompt for you!

### Custom Instructions (`.github/copilot-instructions.md`)

Custom Instructions are **always-on** rules that shape how Copilot responds - across all chat interactions in your workspace. Unlike prompt files (which you invoke explicitly), custom instructions are automatically applied.

Use them to encode your team's coding standards:
```markdown
## Code Standards
- Use functional React components with hooks, never class components
- All TypeScript interfaces must be exported from a types/ directory
- Use kebab-case for file names, PascalCase for components
- All API calls must include error handling with try/catch
```

### Custom Agents (`.agent.md`)

Custom agents let you create **specialized AI personas** with their own tools, instructions, and even model preferences. They're defined as `.agent.md` files in `.github/agents/`:

```markdown
---
description: Terraform infrastructure specialist
tools: ['editFiles', 'runInTerminal', 'codebase', 'fetch']
---

You are a Terraform expert specializing in Azure infrastructure.
Always follow HashiCorp best practices.
Use modular Terraform structure with separate modules for each resource type.
Always include variable validation rules.
```

Switch to your custom agent from the agent dropdown anytime!

### Pre-loaded Terraform Instruction Files (`.github/instructions/`)

This workspace ships with **two Terraform instruction files** in `.github/instructions/` that GitHub Copilot will automatically follow whenever you work on Terraform code. These encode Azure Terraform coding standards and module generation workflows so that Copilot produces compliant infrastructure code out of the box — no extra prompting required.

| File | Purpose |
|------|---------|
| `terraform_coding_standards_azure.instructions.md` | Naming conventions, file structure, variable standards, tag management, and Azure-specific best practices |
| `module_generation_azure.instructions.md` | Step-by-step workflow for generating Core, Pattern, and Configuration Terraform modules |

> 💡 **How it works:** Files with the `.instructions.md` extension in `.github/instructions/` are automatically loaded by GitHub Copilot based on their `applyTo` glob pattern. Because these files use `applyTo: '**'`, they apply to all files in the workspace. You don't need to invoke them — Copilot picks them up automatically.

---

## 📋 Agenda

| Time | Challenge | Title |
|------|-----------|-------|
| 09:00 – 09:30 |  | **Kickoff & Environment Setup** |
| 09:30 – 10:30 | Challenge 1 | 🏗️ The Architect's Blueprint |
| 10:30 – 11:30 | Challenge 2 | 🎨 The Frontend Forge *(Optional)* |
| 11:30 – 12:30 | Challenge 3 | ☁️ Liftoff! Deploy to the Cloud |
| 12:30 – 13:00 |  | **Lunch Break** *(vote on it using your app!)* |
| 13:00 – 14:00 | Challenge 4 | �️ The Data Fortress |
| 14:00 – 15:00 | Challenge 5 | 🔐 The Vault of Secrets |
| 15:00 – 16:00 | Challenge 6 | 🚢 Ship It Like a Pro |
| 16:00 – 16:30 |  | **Demo, Retrospective & Awards** |

---

## 🛠️ Prerequisites & Environment Setup

Complete these steps **before** the hackathon begins (or during the 09:00–09:30 setup window).

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| .NET SDK | 10.x | Backend API runtime |
| Node.js | 20.x+ | Frontend build tooling |
| Terraform | v1.11.4 | Infrastructure as Code |
| Azure CLI | Latest | Azure resource management |
| VS Code | Latest | Code editor |
| GitHub Copilot | Active subscription | AI pair-programmer |
| Git | Latest | Version control |

### Step 1: Install .NET 10 SDK

Check if you already have it:

```powershell
dotnet --version
dotnet --list-sdks
```

If .NET 10.0 is not installed:

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

### Step 2: Install Node.js 20+

```powershell
# Download Node.js
Invoke-WebRequest -Uri "https://nodejs.org/dist/v20.11.1/node-v20.11.1-win-x64.zip" -OutFile "$env:USERPROFILE\Downloads\node.zip"

# Extract to .nodejs folder
Expand-Archive -Path "$env:USERPROFILE\Downloads\node.zip" -DestinationPath "$env:USERPROFILE\.nodejs" -Force

# Move files to parent directory
Move-Item "$env:USERPROFILE\.nodejs\node-v20.11.1-win-x64\*" "$env:USERPROFILE\.nodejs\"

# Add to PATH (current session)
$env:PATH="$env:USERPROFILE\.nodejs;$env:PATH"

# Verify
node --version
npm --version
```

### Step 3: Install Terraform v1.11.4

```powershell
# Download Terraform for Windows
Invoke-WebRequest -Uri "https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_windows_amd64.zip" -OutFile "$env:USERPROFILE\Downloads\terraform.zip"

# Extract to a local directory
Expand-Archive -Path "$env:USERPROFILE\Downloads\terraform.zip" -DestinationPath "C:\terraform" -Force

# Add to PATH (current session)
$env:PATH="C:\terraform;$env:PATH"

# Verify
terraform -version
```

Expected output: `Terraform v1.11.4`

### Step 4: Verify Azure CLI

```powershell
az version
az login
```

### Step 5: Verify GitHub Copilot

- Open VS Code
- Ensure the **GitHub Copilot** and **GitHub Copilot Chat** extensions are installed and active
- Verify the Copilot icon is showing in the status bar

### Step 6: Clone the Repository & Verify the API

```powershell
# Clone the hackathon repo (URL provided by your hackathon host)
git clone <REPO_URL>
cd LunchVoteApp

# Start the backend API
cd src/LunchVoteApi
dotnet run
```

The API runs with an **in-memory database** by default (no SQL Server needed locally). Verify it's working:

```powershell
# In a new terminal  test the API
curl -k https://localhost:52544/api/groups
```

You should see a JSON array of group IDs. The API also has **Swagger UI** at `https://localhost:52544/swagger`.

### Step 7: Explore the API

Familiarize yourself with the API endpoints  you'll be building a UI for them:

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/polls` | Create a new poll |
| `GET` | `/api/polls/active?groupId={groupId}` | Get active poll for a group |
| `GET` | `/api/polls/{pollId}/results` | Get poll results |
| `POST` | `/api/votes` | Submit a vote |
| `GET` | `/api/groups` | Get all group IDs with active polls |

**Create Poll Request Body:**
```json
{
  "groupId": "platform",
  "question": "Where should we eat today?",
  "options": ["Sushi", "Burgers", "Thai", "Pizza"]
}
```

**Submit Vote Request Body:**
```json
{
  "pollId": "<poll-id-from-create>",
  "optionId": "<option-id-from-active-poll>",
  "voterToken": "my-unique-browser-token"
}
```

> 💡 **Tip:** Use Swagger UI to interactively test all endpoints before you start building.

---

## 🏁 Challenges

Each challenge is documented in its own file. Complete them in order (Challenge 2 is optional).

| # | Challenge | Duration | Description |
|---|-----------|----------|-------------|
| 1 | [🏗️ The Architect's Blueprint](challenges/challenge-1.md) | ~60 min | Use GitHub Copilot to author Terraform IaC and provision Azure resources |
| 2 | [🎨 The Frontend Forge *(Optional)*](challenges/challenge-2.md) | ~60 min | Build a React + TypeScript SPA with GitHub Copilot assistance |
| 3 | [☁️ Liftoff! Deploy to the Cloud](challenges/challenge-3.md) | ~60 min | Deploy the backend API and frontend SPA to Azure App Service |
| 4 | [�️ The Data Fortress](challenges/challenge-4.md) | ~60 min | Migrate from in-memory storage to Azure SQL with EF Core |
| 5 | [🔐 The Vault of Secrets](challenges/challenge-5.md) | ~60 min | Secure secrets with Azure Key Vault and Managed Identity |
| 6 | [🚢 Ship It Like a Pro](challenges/challenge-6.md) | ~60 min | Implement Blue/Green deployment with Azure App Service Deployment Slots |

---

## 🎯 Final Demo Checklist

Before the final demo at 16:00, ensure you can demonstrate:

| # | Item | Status |
|---|------|--------|
| 1 | Terraform code authored with GitHub Copilot | ⬜ |
| 2 | React SPA built with GitHub Copilot — renders all 4 screens | ⬜ |
| 3 | Infrastructure provisioned in Azure — all resources visible in Portal | ⬜ |
| 4 | Backend API deployed and responding to requests | ⬜ |
| 5 | Frontend SPA deployed and accessible | ⬜ |
| 6 | Key Vault configured with Managed Identity access | ⬜ |
| 7 | SQL Database connected with Managed Identity (no passwords!) | ⬜ |
| 8 | Data persists across App Service restarts | ⬜ |
| 9 | Blue/Green deployment with staging slot swap demonstrated | ⬜ |
| 10 | SQL Database protected behind a private endpoint (Challenge 6) | ⬜ |
| 11 | Live log streaming shown | ⬜ |

> 💡 **What's next?** Challenge 6 includes a **"Beyond the Hackathon"** section with Azure best practices for production readiness — covering Application Insights, Defender for Cloud, autoscaling, CI/CD with GitHub Actions, and more. Review it after the hackathon to understand what it takes to run enterprise-grade applications on Azure.

---

## 🧹 Cleanup

After the hackathon, delete your Azure resource group to remove all resources and avoid ongoing charges:

```powershell
az group delete --name rg-lunchvote-dev --yes --no-wait
```

---

## 💡 GitHub Copilot Mastery Guide

### Prompting Techniques

| Technique | Example |
|-----------|----------|
| **Be specific** | *"Create a Terraform module for Azure Linux Web App with .NET 8 runtime, B1 SKU, managed identity, HTTPS-only"* |
| **Provide context** | Paste API endpoint tables, type definitions, or error messages into the chat |
| **Iterate** | If the first response isn't right, refine: *"Update this to use RBAC instead of access policies"* |
| **Ask to explain** | *"Explain what `azuread_authentication_only = true` does on an Azure SQL Server"* |
| **Debug together** | Paste error messages and ask: *"I'm getting this error when running terraform apply  what's wrong?"* |
| **Use inline suggestions** | Start typing a line of code and let Copilot auto-complete the rest |
| **Use `@workspace`** | Ask Copilot about your codebase: *"@workspace What API endpoints does the backend expose?"* |
| **Use `#codebase`** | *"#codebase Find all places where the connection string is configured"* |
| **Use `@terminal`** | *"@terminal How do I check if my Terraform state is up to date?"* |
| **Multi-turn conversations** | Ask follow-up questions - Copilot remembers the full conversation context |

### Keyboard Shortcuts Cheat Sheet

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+I` | Open Chat view |
| `Ctrl+Shift+I` | Switch to Agent mode |
| `Ctrl+I` | Inline Chat (editor or terminal) |
| `Ctrl+Shift+Alt+L` | Quick Chat |
| `Tab` | Accept inline suggestion |
| `Escape` | Dismiss inline suggestion |
| `Ctrl+Alt+.` | Open model picker |
| `Ctrl+N` | New chat session |

### Copilot Features Quick Reference

| Feature | File/Location | Purpose |
|---------|---------------|---------|
| **Custom Instructions** | `.github/copilot-instructions.md` | Always-on coding standards |
| **Prompt Files** | `.github/prompts/*.prompt.md` | Reusable task specifications |
| **Custom Agents** | `.github/agents/*.agent.md` | Specialized AI personas |
| **Path-Specific Instructions** | `.github/instructions/*.instructions.md` | Rules for specific file types |

---

## 📚 Quick Reference  API Contract

### Request/Response Models

**CreatePollRequest:**
```json
{
  "groupId": "string (required, max 50 chars)",
  "question": "string (required, max 200 chars)",
  "options": ["string (required, max 100 chars each, 2-10 items)"]
}
```

**CreatePollResponse:**
```json
{
  "pollId": "guid"
}
```

**ActivePoll (GET /api/polls/active):**
```json
{
  "pollId": "guid",
  "groupId": "string",
  "question": "string",
  "options": [
    { "optionId": "guid", "text": "string" }
  ]
}
```

**VoteRequest:**
```json
{
  "pollId": "guid",
  "optionId": "guid",
  "voterToken": "string (unique per browser)"
}
```

**PollResults (GET /api/polls/{id}/results):**
```json
{
  "pollId": "guid",
  "question": "string",
  "results": [
    { "optionId": "guid", "text": "string", "count": 0 }
  ],
  "totalVotes": 0
}
```

**ErrorResponse (4xx/5xx):**
```json
{
  "error": "ErrorCode",
  "message": "Human-readable description"
}
```

---

## Appendix A: Common API Deployment Issues & Troubleshooting


### Issue 1: .NET Runtime Version Mismatch (Terraform deploys .NET 8.0, App targets .NET 10)

**Symptom:** The App Service is configured with `.NET 8.0` runtime (as set by Terraform), but the Lunch Vote API targets `.NET 10`. The app may fail to start or behave unexpectedly.

**Root Cause:** The Terraform modules in `infra/terraform/` (and `infra/bicep/`) configure the App Service with `.NET 8.0 LTS` as the runtime stack. Since the API project targets `net10.0`, the deployed App Service needs to be updated to match.

**Fix - Update via Azure CLI after `terraform apply`:**

```powershell
# Check current runtime
az webapp config show --resource-group rg-lunchvote-dev --name <API_APP_NAME> --query "linuxFxVersion" -o tsv

# Update to .NET 10
az webapp config set --resource-group rg-lunchvote-dev --name <API_APP_NAME> --linux-fx-version "DOTNETCORE|10.0"

# Restart the app
az webapp restart --resource-group rg-lunchvote-dev --name <API_APP_NAME>
```

> ⚠️ **Important:** Always ensure your App Service runtime version matches your project's target framework. Check `<TargetFramework>` in your `.csproj` file.

---

### Issue 2: Zip Deploy Fails with `System.IO.IOException: Invalid argument` (BuildHost-netcore folder)

**Symptom:** Running `az webapp deploy --type zip` returns a **500 error** with a stack trace containing:

```
System.IO.IOException: Invalid argument :
  '/home/site/wwwroot/BuildHost-netcore\it\System.CommandLine.resources.dll'
```

**Root Cause:** The `dotnet publish` output on Windows includes a `BuildHost-netcore` folder that contains files with **Windows-style backslash paths** (e.g., `it\System.CommandLine.resources.dll`). Azure App Service runs on **Linux**, where backslashes in filenames are invalid. When Kudu tries to extract and copy these files, it fails.

**Fix - Remove the folder before zipping:**

```powershell
# Publish
dotnet publish src/LunchVoteApi/LunchVoteApi.csproj -c Release -o ./publish

# Remove the problematic folder
Remove-Item -Recurse -Force ./publish/BuildHost-netcore -ErrorAction SilentlyContinue

# Zip and deploy
Compress-Archive -Path ./publish/* -DestinationPath ./lunchvoteapi.zip -Force
az webapp deploy --resource-group <RG_NAME> --name <API_APP_NAME> --src-path ./lunchvoteapi.zip --type zip
```

> 💡 **Tip:** Always check the publish output for any folders with backslash paths before zipping for a Linux App Service.

---

### Issue 3: API Returns 500 `"An unexpected error occurred."` After Successful Deployment

**Symptom:** The App Service starts successfully (container logs show `Application started`), but every API call returns:

```json
{"error":"InternalError","message":"An unexpected error occurred."}
```

**Root Cause:** The Terraform/Bicep deployment configures a **SQL connection string** (`DefaultConnection`) on the App Service using `Active Directory Default` authentication. However, the App Service's **Managed Identity has not been added as a SQL user** - the `infra/scripts/create-sql-user.sql` script hasn't been executed yet. When the API tries to query the database, the connection fails and the global exception handler returns a generic 500.

**Quick Fix - Use in-memory database for initial testing:**

Remove the connection string so the app falls back to its built-in in-memory database with mock data:

```powershell
# Remove the SQL connection string
az webapp config connection-string delete \
  --resource-group <RG_NAME> \
  --name <API_APP_NAME> \
  --setting-names DefaultConnection

# Restart the app
az webapp restart --resource-group <RG_NAME> --name <API_APP_NAME>

# Test - should now return mock data
curl -s https://<API_APP_NAME>.azurewebsites.net/api/groups
# Expected: ["platform","security"]
```

**Proper Fix - Create the SQL user for Managed Identity (Challenge 4):**

1. Update the app service name in `infra/scripts/create-sql-user.sql` to match your actual app name (including the random suffix)
2. Run the SQL script against `sqldb-lunchvote` while connected as the Entra admin
3. Restore the connection string:

```powershell
az webapp config connection-string set \
  --resource-group <RG_NAME> \
  --name <API_APP_NAME> \
  --settings DefaultConnection="Server=tcp:<SQL_SERVER>.database.windows.net,1433;Database=sqldb-lunchvote;Authentication=Active Directory Default;" \
  --connection-string-type SQLAzure
```

> 💡 **Debugging Tip:** To see the actual exception, enable application logging:
> ```powershell
> az webapp log config --resource-group <RG_NAME> --name <API_APP_NAME> \
>   --application-logging filesystem --level information
> az webapp log download --resource-group <RG_NAME> --name <API_APP_NAME> \
>   --log-file ./app-logs.zip
> ```

---

### Issue 4: Application Logging Not Enabled by Default

**Symptom:** You're getting errors but can't find any useful logs in the downloaded log files - the Docker container logs show the app started, but no application-level errors are captured.

**Root Cause:** By default, Azure App Service has **application logging disabled** (`fileSystem.level: Off`). The container/platform logs only show startup events, not application exceptions.

**Fix - Enable application logging:**

```powershell
# Enable file system logging at Information level
az webapp log config --resource-group <RG_NAME> --name <API_APP_NAME> \
  --application-logging filesystem --level information

# Trigger the failing request
curl -s https://<API_APP_NAME>.azurewebsites.net/api/groups

# Download and inspect logs
az webapp log download --resource-group <RG_NAME> --name <API_APP_NAME> \
  --log-file ./app-logs.zip
```

> 💡 **Tip:** Enable logging **before** you start debugging. It's much easier to diagnose issues when you can see the actual exception stack traces.

---

### Quick Reference: Deployment Troubleshooting Checklist

| # | Check | Command |
|---|-------|---------|
| 1 | Verify .NET runtime version matches your app | `az webapp config show -g <RG> -n <APP> --query linuxFxVersion -o tsv` |
| 2 | Check if the app is running | `curl -s https://<APP>.azurewebsites.net/api/groups` |
| 3 | View App Service app settings | `az webapp config appsettings list -g <RG> -n <APP> -o table` |
| 4 | View connection strings | `az webapp config connection-string list -g <RG> -n <APP> -o table` |
| 5 | Check Managed Identity | `az webapp identity show -g <RG> -n <APP> --query principalId -o tsv` |
| 6 | Enable application logging | `az webapp log config -g <RG> -n <APP> --application-logging filesystem --level information` |
| 7 | Download logs | `az webapp log download -g <RG> -n <APP> --log-file ./logs.zip` |
| 8 | Restart the app | `az webapp restart -g <RG> -n <APP>` |

---

## Appendix B: Common Frontend (SPA) Deployment Issues & Troubleshooting


### Issue 5: Zip Deploy Returns 400 Bad Request (`SCM_DO_BUILD_DURING_DEPLOYMENT`)

**Symptom:** Running `az webapp deploy --type zip` for the frontend returns a **400 Bad Request**. The Kudu deployment log may show errors about missing `package.json` or failed `npm install`.

**Root Cause:** The frontend App Service has the app setting `SCM_DO_BUILD_DURING_DEPLOYMENT=true` (set by Terraform/Bicep). This tells Kudu to run a build (e.g., `npm install && npm run build`) during deployment. Since you’re deploying **pre-built static files** (the `dist/` output from Vite), there’s no `package.json` or `node_modules` in the zip, and the build step fails.

**Fix - Disable remote build before deploying pre-built artifacts:**

```powershell
# Disable remote build
az webapp config appsettings set \
  --resource-group <RG_NAME> --name <SPA_APP_NAME> \
  --settings SCM_DO_BUILD_DURING_DEPLOYMENT=false

# Now deploy
az webapp deploy --resource-group <RG_NAME> --name <SPA_APP_NAME> \
  --src-path ./dist.zip --type zip
```

> 💡 **Tip:** If you want Kudu to build from source instead, deploy the entire project directory (including `package.json`) and keep `SCM_DO_BUILD_DURING_DEPLOYMENT=true`.

---

### Issue 6: Frontend Returns Empty Page or Application Error

**Symptom:** After successful zip deployment, navigating to `https://<SPA_APP_NAME>.azurewebsites.net` shows the Azure default page, an empty page, or "Application Error".

**Root Cause:** The Node.js App Service doesn’t know how to serve static files. By default it looks for a `server.js` or `index.js` entry point. Since the Vite build output is just static HTML/CSS/JS, you need to configure a static file server.

**Fix - Set the startup command to use pm2 serve:**

```powershell
# Configure pm2 to serve the static SPA with client-side routing support
az webapp config set \
  --resource-group <RG_NAME> --name <SPA_APP_NAME> \
  --startup-file "pm2 serve /home/site/wwwroot --no-daemon --spa"

# Restart
az webapp restart --resource-group <RG_NAME> --name <SPA_APP_NAME>
```

> ⚠️ **Important:** The `--spa` flag tells pm2 to redirect all routes to `index.html`, which is required for React Router to work correctly. Without it, refreshing on any non-root route (e.g., `/vote`) will return a 404.

---

### Issue 7: CORS — Frontend Cannot Call the API

**Symptom:** The SPA loads correctly, but API calls fail with CORS errors in the browser console:

```
Access to fetch at 'https://<API_APP_NAME>.azurewebsites.net/api/...' 
from origin 'https://<SPA_APP_NAME>.azurewebsites.net' has been blocked by CORS policy
```

**Root Cause:** The API doesn’t recognize the frontend’s Azure URL as an allowed origin. CORS must be configured in **two places**:

1. **Azure-level CORS** (App Service platform) — the first layer the request hits
2. **.NET application CORS** (via `AllowedOrigins` config) — the middleware inside the API

**Fix - Configure both layers:**

```powershell
# 1. Azure-level CORS on the API App Service
az webapp cors add \
  --resource-group <RG_NAME> --name <API_APP_NAME> \
  --allowed-origins "https://<SPA_APP_NAME>.azurewebsites.net"

# 2. .NET application CORS via App Settings
#    The API reads AllowedOrigins from config (array indexed by __0, __1, etc.)
az webapp config appsettings set \
  --resource-group <RG_NAME> --name <API_APP_NAME> \
  --settings \
    AllowedOrigins__0="https://<SPA_APP_NAME>.azurewebsites.net" \
    AllowedOrigins__1="http://localhost:5173" \
    AllowedOrigins__2="http://localhost:3000"

# 3. Restart the API to pick up the new settings
az webapp restart --resource-group <RG_NAME> --name <API_APP_NAME>
```

**Verify CORS is working:**

```powershell
curl -s -o /dev/null -w "%{http_code}" \
  -H "Origin: https://<SPA_APP_NAME>.azurewebsites.net" \
  "https://<API_APP_NAME>.azurewebsites.net/api/groups"
```

> 💡 **How the API CORS config works:** `Program.cs` reads an `AllowedOrigins` string array from configuration (see lines 42–54). In `appsettings.json` this defaults to localhost URLs for local development. In Azure, App Settings with the `AllowedOrigins__N` naming convention override the array elements. This means **no code changes are needed** — just set the App Settings.

---

### Issue 8: `VITE_API_URL` Must Be Set at Build Time, Not Runtime

**Symptom:** The deployed SPA makes API calls to `/api` (relative URL) instead of the full API URL `https://<API_APP_NAME>.azurewebsites.net/api`, resulting in 404 errors.

**Root Cause:** Vite replaces `import.meta.env.VITE_API_URL` at **build time**, not at runtime. If you run `npm run build` without setting the environment variable, it falls back to `/api` (the default in `api.ts`). Since the SPA and API are on different domains, relative URLs won’t work.

**Fix - Set the environment variable before building:**

```powershell
# PowerShell
$env:VITE_API_URL = "https://<API_APP_NAME>.azurewebsites.net/api"
npm run build
```

```bash
# Bash / Linux
VITE_API_URL=https://<API_APP_NAME>.azurewebsites.net/api npm run build
```

> ⚠️ **Important:** You must rebuild the SPA every time the API URL changes. The URL is baked into the JavaScript bundle at build time.

---

### Quick Reference: Frontend Deployment Troubleshooting Checklist

| # | Check | Command |
|---|-------|---------|
| 1 | Disable remote build for pre-built artifacts | `az webapp config appsettings set -g <RG> -n <SPA> --settings SCM_DO_BUILD_DURING_DEPLOYMENT=false` |
| 2 | Set pm2 serve startup command | `az webapp config set -g <RG> -n <SPA> --startup-file "pm2 serve /home/site/wwwroot --no-daemon --spa"` |
| 3 | Build SPA with correct API URL | `$env:VITE_API_URL="https://<API>.azurewebsites.net/api"; npm run build` |
| 4 | Add Azure CORS on API | `az webapp cors add -g <RG> -n <API> --allowed-origins "https://<SPA>.azurewebsites.net"` |
| 5 | Set .NET AllowedOrigins on API | `az webapp config appsettings set -g <RG> -n <API> --settings AllowedOrigins__0="https://<SPA>.azurewebsites.net"` |
| 6 | Verify SPA serves HTML | `curl -s -o /dev/null -w "%{http_code}" https://<SPA>.azurewebsites.net` |
| 7 | Verify CORS headers | `curl -sI -H "Origin: https://<SPA>.azurewebsites.net" https://<API>.azurewebsites.net/api/groups` |
| 8 | Restart both apps | `az webapp restart -g <RG> -n <API>; az webapp restart -g <RG> -n <SPA>` |

---

## Appendix C: Azure SQL & Managed Identity Troubleshooting (Challenge 4)

---

### Issue 9: SQL Server Has Public Network Access Disabled

**Symptom:** Attempting to connect to Azure SQL from your local machine (via `sqlcmd`, a .NET script, or SSMS) fails with:

```
Connection was denied because Deny Public Network Access is set to Yes.
```

**Root Cause:** The Terraform module may deploy the SQL server with `public_network_access_enabled = false` (or the Azure portal default is Disabled). Without public access, only Azure-internal connections and private endpoints can reach the server.

**Fix - Temporarily enable public access for admin scripts, then re-disable if desired:**

```powershell
# Enable public network access
az sql server update --name <SQL_SERVER_NAME> --resource-group <RG> --enable-public-network true

# Add your local IP to the firewall
$myIp = (Invoke-RestMethod -Uri "https://api.ipify.org")
az sql server firewall-rule create --server <SQL_SERVER_NAME> --resource-group <RG> \
  --name "LocalAdmin" --start-ip-address $myIp --end-ip-address $myIp

# ... run your admin SQL scripts ...

# Remove the temporary firewall rule when done
az sql server firewall-rule delete --server <SQL_SERVER_NAME> --resource-group <RG> --name "LocalAdmin"
```

> 💡 **Note:** The `AllowAllWindowsAzureIps` firewall rule (`0.0.0.0–0.0.0.0`) only allows Azure-hosted services (like App Service) to connect. It does **not** allow connections from your developer machine.

---

### Issue 10: `sqlcmd -G` Fails with MFA Required Error

**Symptom:** Running `sqlcmd` with Azure AD authentication (`-G` flag) fails with:

```
Failed to authenticate the user '' in Active Directory (Authentication option is 'ActiveDirectoryIntegrated').
AADSTS50076: Due to a configuration change made by your administrator... you must use multi-factor authentication
```

**Root Cause:** The `-G` flag uses `ActiveDirectoryIntegrated` (Windows Integrated / Kerberos), which does not support MFA. If your tenant enforces MFA via Conditional Access, this authentication method will always fail.

**Fix - Use a .NET script with `Active Directory Default` auth, which honours Azure CLI cached credentials:**

```powershell
# Create a temporary .NET console app
$tmpDir = "$env:TEMP\sql-admin-$(Get-Random)"
New-Item -ItemType Directory -Path $tmpDir | Out-Null
Set-Location "$tmpDir"
dotnet new console -n SqlAdmin --no-restore
Set-Location SqlAdmin
dotnet add package Microsoft.Data.SqlClient

# Write the script
@'
using Microsoft.Data.SqlClient;

var connStr = "Server=tcp:<SQL_SERVER>.database.windows.net,1433;Database=<DB_NAME>;Authentication=Active Directory Default;Connect Timeout=30;";

// Replace with your App Service name
var appServiceName = "<APP_SERVICE_NAME>";

var sql = $"""
    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = '{appServiceName}')
        EXEC('CREATE USER [{appServiceName}] FROM EXTERNAL PROVIDER;');
    ALTER ROLE db_datareader ADD MEMBER [{appServiceName}];
    ALTER ROLE db_datawriter ADD MEMBER [{appServiceName}];
    ALTER ROLE db_ddladmin  ADD MEMBER [{appServiceName}];
    """;

using var conn = new SqlConnection(connStr);
conn.Open();
Console.WriteLine("Connected!");
using var cmd = new SqlCommand(sql, conn);
cmd.ExecuteNonQuery();
Console.WriteLine("Managed identity user configured successfully.");
'@ | Set-Content Program.cs

dotnet run
```

> 💡 **How it works:** `Active Directory Default` uses the [DefaultAzureCredential](https://learn.microsoft.com/en-us/dotnet/api/azure.identity.defaultazurecredential) chain, which picks up your `az login` token automatically. No MFA prompt needed after your initial CLI login.

---

### Issue 11: EF Core `EnsureCreated()` Fails — Tables Not Created After First Startup

**Symptom:** The App Service starts without error, but API calls return 500. Querying `INFORMATION_SCHEMA.TABLES` shows the database is empty — no `Poll`, `Option`, or `Vote` tables.

**Root Cause:** EF Core's `EnsureCreated()` needs to execute `CREATE TABLE` DDL statements. By default, the `db_datareader` and `db_datawriter` roles only grant **DML** permissions (SELECT, INSERT, UPDATE, DELETE). They do **not** grant permission to create or modify schema objects.

**Fix - Grant the `db_ddladmin` role to the managed identity:**

```powershell
# Run against your database as the Entra ID admin (see Issue 10 for how to connect)
ALTER ROLE db_ddladmin ADD MEMBER [<APP_SERVICE_NAME>];
```

Or include it in the managed identity setup script alongside the other roles:

```sql
-- Run as Entra ID administrator
CREATE USER [<APP_SERVICE_NAME>] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [<APP_SERVICE_NAME>];
ALTER ROLE db_datawriter ADD MEMBER [<APP_SERVICE_NAME>];
ALTER ROLE db_ddladmin   ADD MEMBER [<APP_SERVICE_NAME>];  -- Required for EnsureCreated()
```

After granting the role, **restart the App Service** so `EnsureCreated()` runs again on startup:

```powershell
az webapp restart --name <APP_SERVICE_NAME> --resource-group <RG>
```

> ⚠️ **Important:** `ASPNETCORE_ENVIRONMENT` must be set to `Development` on the App Service for `EnsureCreated()` to run. The code in `Program.cs` only calls `EnsureCreated()` inside `if (app.Environment.IsDevelopment())`. Verify with:
> ```powershell
> az webapp config appsettings list -g <RG> -n <APP_SERVICE_NAME> --query "[?name=='ASPNETCORE_ENVIRONMENT']"
> ```

---

### Issue 12: Managed Identity SQL User Already Exists — Role Grant Still Required

**Symptom:** Running `CREATE USER [...] FROM EXTERNAL PROVIDER` returns an error saying the user already exists, but the API still returns 500 errors when querying the database.

**Root Cause:** The user may have been created in a previous attempt without the necessary roles being granted. Existence of the database principal doesn't guarantee it has the correct role memberships.

**Fix - Check and grant roles idempotently:**

```sql
-- Safe to run multiple times
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = '<APP_SERVICE_NAME>')
    EXEC('CREATE USER [<APP_SERVICE_NAME>] FROM EXTERNAL PROVIDER;');

ALTER ROLE db_datareader ADD MEMBER [<APP_SERVICE_NAME>];
ALTER ROLE db_datawriter ADD MEMBER [<APP_SERVICE_NAME>];
ALTER ROLE db_ddladmin   ADD MEMBER [<APP_SERVICE_NAME>];
```

To verify role membership:

```sql
SELECT dp.name AS principal_name, r.name AS role_name
FROM sys.database_role_members rm
JOIN sys.database_principals dp ON rm.member_principal_id = dp.principal_id
JOIN sys.database_principals r  ON rm.role_principal_id  = r.principal_id
WHERE dp.name = '<APP_SERVICE_NAME>';
```

---

### Quick Reference: Challenge 4 SQL Setup Checklist

| # | Step | Command / Note |
|---|------|----------------|
| 1 | Enable SQL public network access (for local admin scripts) | `az sql server update --name <SQL> -g <RG> --enable-public-network true` |
| 2 | Add your local IP to the SQL firewall | `az sql server firewall-rule create --name LocalAdmin --start-ip-address <IP> --end-ip-address <IP>` |
| 3 | Verify the `AllowAllWindowsAzureIps` rule exists | `az sql server firewall-rule list --server <SQL> -g <RG> -o table` |
| 4 | Create managed identity SQL user (use .NET script, not `sqlcmd -G`) | See Issue 10 above |
| 5 | Grant `db_datareader`, `db_datawriter`, **and `db_ddladmin`** | Required for EF Core `EnsureCreated()` |
| 6 | Verify `ASPNETCORE_ENVIRONMENT=Development` is set | `az webapp config appsettings list -g <RG> -n <APP> -o table` |
| 7 | Set the connection string on the App Service | `az webapp config connection-string set ... --settings DefaultConnection="Server=tcp:<SQL>.database.windows.net,1433;Database=<DB>;Authentication=Active Directory Default;"` |
| 8 | Remove temporary local firewall rule | `az sql server firewall-rule delete --name LocalAdmin` |
| 9 | Restart App Service to trigger `EnsureCreated()` | `az webapp restart -g <RG> -n <APP_SERVICE_NAME>` |
| 10 | Verify tables created & API responds 200 | `curl https://<APP_SERVICE_NAME>.azurewebsites.net/api/groups` |

---

## 🏅 Good Luck, Hackers!

Remember  this hackathon is about **learning**, not perfection. Experiment boldly, break things, and let GitHub Copilot guide you through unfamiliar territory. The best learning happens when you're outside your comfort zone.

**Now go build something awesome!** 🚀

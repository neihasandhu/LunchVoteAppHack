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

## GitHub Copilot Deep Dive — Your AI Toolkit

Before we begin, let's understand the **GitHub Copilot features** you'll be mastering today. Each challenge deliberately introduces a different Copilot capability so that by the end of the day, you'll be a Copilot power user.

### Built-in Agents (Chat Personas)

GitHub Copilot in VS Code offers three built-in **agents** — each optimized for different workflows. You select an agent from the dropdown at the top of the Chat view:

| Agent | Shortcut | What It Does | When to Use It |
|-------|----------|--------------|----------------|
| **Agent** | `Ctrl+Shift+I` | Autonomously plans, edits files, runs terminal commands, and invokes tools across your workspace | Building features, fixing bugs, scaffolding projects |
| **Plan** | `/plan` | Creates a structured, step-by-step implementation plan *without* writing code. Hands off to Agent when approved | Complex tasks, architecture decisions, before major changes |
| **Ask** | `Ctrl+Alt+I` | Answers questions about coding concepts, your codebase, or VS Code itself. Read-only — never modifies files | Learning, exploration, understanding unfamiliar code |

> 💡 **Pro Tip:** Start with **Plan** to think through your approach, then hand off to **Agent** to implement it. This mirrors real-world software engineering: *design first, code second*.

### Specification-Driven Development with Prompt Files

One of the most powerful (and underused) Copilot features is **Prompt Files** (`.prompt.md`) — reusable, shareable specification files that encode *what* you want built. Think of them as a **spec kit** for AI-assisted development:

- **What:** Markdown files with a `.prompt.md` extension stored in `.github/prompts/`
- **Why:** Instead of typing the same long prompt repeatedly, you encode your specification once and invoke it with `/prompt-name` in chat
- **How:** They support YAML frontmatter for configuring which agent, model, and tools to use, plus Markdown body with detailed instructions
- **Bonus:** You can reference workspace files, use variables like `${selection}` and `${input:componentName}`, and share them with your team via Git

**Example — A React Component Spec:**
```markdown
---
description: Generate a React component from specification
agent: agent
tools: ['editFiles', 'runInTerminal', 'codebase']
---

Create a React functional component with TypeScript.

Requirements:
- Use React hooks (useState, useEffect) as needed
- Include proper TypeScript interfaces for all props
- Add JSDoc comments for the component and its props
- Include error handling for any API calls
- Follow the existing project patterns in [src/](../../src/lunch-vote-spa/src/)

Component name: ${input:componentName}
Component purpose: ${input:description}
```

You invoke it in chat by typing: `/react-component` — and Copilot builds it to your exact spec!

### Custom Instructions (`.github/copilot-instructions.md`)

Custom Instructions are **always-on** rules that shape how Copilot responds — across all chat interactions in your workspace. Unlike prompt files (which you invoke explicitly), custom instructions are automatically applied.

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

### Key Copilot Interactions at a Glance

| Feature | How to Access | Purpose |
|---------|---------------|----------|
| **Inline Suggestions** | Just start typing | Auto-complete code as you type |
| **Inline Chat** | `Ctrl+I` in editor | Quick edits without leaving your code |
| **Chat View** | `Ctrl+Alt+I` | Full conversations with context |
| **Quick Chat** | `Ctrl+Shift+Alt+L` | Fast question without switching views |
| **`#` Context** | Type `#` in chat | Attach files, folders, tools, codebase |
| **`@` Participants** | Type `@` in chat | `@workspace`, `@terminal`, `@vscode` |
| **`/` Commands** | Type `/` in chat | `/fix`, `/tests`, `/explain`, `/doc`, `/plan` |
| **Prompt Files** | `/prompt-name` | Run reusable specs |
| **Custom Agents** | Agent dropdown | Switch to specialized personas |
| **Vision** | Drag image into chat | Describe UI from screenshots/mockups |
| **Code Review** | Source Control view | AI-powered review of uncommitted changes |

### Copilot Features by Challenge

| Challenge | Primary Copilot Feature Introduced |
|-----------|--------------------------------------|
| 1 — The Architect's Blueprint | **Agent mode** + **Custom Agents** for Terraform |
| 2 — The Frontend Forge | **Prompt Files (Spec Kit)** + **Plan Agent** + **Vision** |
| 3 — Liftoff! Deploy to the Cloud | **`@terminal`** participant + **Inline Chat** in terminal |
| 4 — The Vault of Secrets | **Ask Agent** for learning + **`/explain`** command |
| 5 — The Data Fortress | **Custom Instructions** + **`#codebase`** context |
| 6 — Ship It Like a Pro | **Code Review** + **Commit Message Generation** |

---

## 📋 Agenda

| Time | Challenge | Title |
|------|-----------|-------|
| 09:00 – 09:30 |  | **Kickoff & Environment Setup** |
| 09:30 – 10:30 | Challenge 1 | 🏗️ The Architect's Blueprint |
| 10:30 – 11:30 | Challenge 2 | 🎨 The Frontend Forge |
| 11:30 – 12:30 | Challenge 3 | ☁️ Liftoff! Deploy to the Cloud |
| 12:30 – 13:00 |  | **Lunch Break** *(vote on it using your app!)* |
| 13:00 – 14:00 | Challenge 4 | 🔐 The Vault of Secrets |
| 14:00 – 15:00 | Challenge 5 | 🗃️ The Data Fortress |
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

## 🏆 Challenge Scoring

Each challenge is scored on the following criteria:

| Criteria | Points |
|----------|--------|
| **Acceptance Criteria Met** | 60 |
| **Effective Use of GitHub Copilot** | 20 |
| **Code Quality & Best Practices** | 10 |
| **Creativity & Polish** | 10 |

Judges will review your GitHub Copilot chat history, commit messages, and final working solution.

---

## Challenge 1: 🏗️ The Architect's Blueprint

### *"Every skyscraper starts with a blueprint  yours is written in Terraform"*

**Duration:** ~60 minutes

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

Using GitHub Copilot in VS Code, author your own Terraform configuration from scratch to provision the Lunch Vote App's Azure infrastructure.

> ⚠️ **Important:** You must write your own Terraform code with the assistance of GitHub Copilot. Do NOT copy from any existing templates. Ask Copilot questions, iterate on the generated code, and learn how each resource works.

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

### Acceptance Criteria

| # | Criteria | Details |
|---|----------|---------|
| ✅ 1 | **Provider configuration** | Terraform `azurerm` provider ~> 3.0 is configured with required features block |
| ✅ 2 | **Resource Group** | An Azure Resource Group is created with naming convention `rg-lunchvote-{environment}` |
| ✅ 3 | **Backend App Service** | A Linux App Service Plan (B1 SKU) and App Service with .NET 8.0 runtime, `SystemAssigned` managed identity, HTTPS-only, TLS 1.2+, and CORS configured for `http://localhost:5173` |
| ✅ 4 | **Frontend App Service** | A separate Linux App Service Plan (B1 SKU) and App Service with Node.js 20 LTS runtime, `SystemAssigned` managed identity, HTTPS-only, TLS 1.2+ |
| ✅ 5 | **SQL Server & Database** | Azure SQL Server with **Entra ID authentication only** (no SQL password), a database named `sqldb-lunchvote` with Basic tier and 2GB max size, and a firewall rule allowing Azure services |
| ✅ 6 | **Key Vault** | Azure Key Vault with RBAC authorization enabled, standard SKU, and soft delete |
| ✅ 7 | **Key Vault Access** | An `azurerm_role_assignment` granting the backend App Service's managed identity the **"Key Vault Secrets User"** role |
| ✅ 8 | **Connection String** | The backend App Service has a SQL connection string configured using `Active Directory Default` authentication |
| ✅ 9 | **Variables** | Input variables defined for: `environment` (with validation for dev/stg/prod), `location`, `sql_admin_object_id`, `sql_admin_login`, and `deploy_static_web_app` |
| ✅ 10 | **Outputs** | Outputs defined for: API App Service name/hostname/URL, Frontend App Service name/hostname/URL, SQL Server FQDN, SQL Database name |
| ✅ 11 | **Validation** | `terraform init` and `terraform validate` pass without errors |
| ✅ 12 | **GitHub Copilot** | Demonstrate that GitHub Copilot assisted in writing the Terraform code (show chat history or inline suggestions) |

### 🤖 GitHub Copilot Skill Focus: Agent Mode + Custom Agents

This challenge introduces **Agent mode** and **Custom Agents** — the most powerful way to use Copilot for code generation.

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
- Use azurerm provider ~> 3.0
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
- **Inline suggestions**: Open a `.tf` file and start typing `resource "azurerm_` — watch Copilot auto-complete the resource block
- **`@terminal`**: In chat, ask `@terminal how do I initialize Terraform in my infra directory?`
- **`/explain`**: Select a Terraform block and use `/explain` to understand what it does

---

## Challenge 2: 🎨 The Frontend Forge

### *"Craft a pixel-perfect voting experience  powered by AI"*

**Duration:** ~60 minutes

### Synopsis

The backend API is ready and waiting. Now it's time to give it a face. In this challenge, you'll build a **React + TypeScript** single-page application (SPA) from scratch using **Vite** as your build tool and **GitHub Copilot** as your AI pair-programmer. Your SPA will let users browse teams, create polls, cast votes, and view live results.

### What You'll Learn

#### React & Component-Based Architecture
**React** is a JavaScript library for building user interfaces using reusable **components**. Each component manages its own state and renders a piece of the UI. Components compose together like building blocks to create complex interfaces. In this challenge, you'll build components for the home screen, voting screen, poll creation, and results display.

#### TypeScript
TypeScript adds **static typing** to JavaScript, catching bugs at compile time rather than runtime. You'll define **interfaces** for your API data models (polls, votes, options, results), ensuring type safety throughout your application.

#### Vite
**Vite** (French for "fast") is a modern frontend build tool that offers lightning-fast development server startup and hot module replacement (HMR). Unlike traditional bundlers, Vite serves source files directly using native ES modules, making development incredibly responsive.

#### React Router
For client-side navigation between screens (home → voting → results), you'll use **React Router**, which maps URL paths to React components without full page reloads.

#### SPA Architecture
A **Single-Page Application** loads once and dynamically updates content as the user navigates. This creates a fluid, app-like experience. The SPA communicates with the backend API via HTTP requests (fetch/axios), sending JSON payloads and receiving JSON responses.

### Your Mission

Using GitHub Copilot, create a React + TypeScript SPA that integrates with the provided Lunch Vote API. The API is already running locally at `https://localhost:52544` with mock data.

> ⚠️ **Important:** You must build your own frontend with the assistance of GitHub Copilot. Do NOT copy from any existing templates. Let Copilot help you scaffold components, write API service functions, and style the interface.

### Application Screens to Build

1. **Home Screen**  Enter or select a team/group name to navigate to their poll
2. **Vote Screen**  View the active poll for a group, select an option, and submit a vote
3. **Create Poll Screen**  Create a new poll when no active poll exists for a group
4. **Results Screen**  View vote counts and percentages as a bar chart or visual display

### 🤖 GitHub Copilot Skill Focus: Specification-Driven Development with Prompt Files (Spec Kit)

This challenge introduces **Prompt Files** — your personal **spec kit** for driving Copilot with reusable, structured specifications. Instead of typing ad-hoc prompts, you'll write specifications that encode exactly what you want built.

#### Step-by-Step: Build Your Spec Kit

**1. Create the prompts directory:**
```powershell
mkdir -p .github/prompts
```

**2. Create a project scaffold spec** — `.github/prompts/scaffold-react-app.prompt.md`:
```markdown
---
description: Scaffold a React + TypeScript SPA with Vite
agent: agent
tools: ['editFiles', 'runInTerminal', 'createFile', 'listDirectory']
---

Scaffold a new React + TypeScript project using Vite in `src/lunch-vote-spa/`.

## Requirements
- Use React 18+ with TypeScript 5+
- Install react-router-dom for client-side routing
- Configure Vite proxy to forward /api requests to https://localhost:52544
- Create the following route structure:
  - `/` → Home screen
  - `/group/:groupId` → Vote screen
  - `/group/:groupId/create` → Create poll screen
  - `/poll/:pollId/results` → Results screen

## Project Structure
```
src/lunch-vote-spa/
├── src/
│   ├── App.tsx           # Router setup
│   ├── main.tsx          # Entry point
│   ├── components/       # React components (one per screen)
│   ├── services/         # API service layer
│   └── types/            # TypeScript interfaces
└── package.json
```
```

**3. Create a component generation spec** — `.github/prompts/react-component.prompt.md`:
```markdown
---
description: Generate a React component from specification
agent: agent
tools: ['editFiles', 'codebase', 'readFile']
---

Create a React functional component with TypeScript for the Lunch Vote App.

## Component Specification
- **Name:** ${input:componentName}
- **Purpose:** ${input:description}

## Standards
- Use React hooks (useState, useEffect, useCallback) as needed
- Define TypeScript interfaces for all props
- Include loading states and error handling
- Add JSDoc comments
- Use CSS modules or a separate .css file for styling
- Follow existing patterns from the project's components/ directory
```

**4. Create an API service spec** — `.github/prompts/api-service.prompt.md`:
```markdown
---
description: Generate the API service layer for Lunch Vote App
agent: agent
tools: ['editFiles', 'codebase']
---

Generate a TypeScript API service layer in `src/lunch-vote-spa/src/services/api.ts`.

## API Endpoints to integrate:
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST   | /api/polls | Create a new poll |
| GET    | /api/polls/active?groupId={groupId} | Get active poll |
| GET    | /api/polls/{pollId}/results | Get poll results |
| POST   | /api/votes | Submit a vote |
| GET    | /api/groups | Get all group IDs |

## Requirements:
- Use the Fetch API (no axios)
- Base URL from `import.meta.env.VITE_API_URL` with fallback to '/api'
- Create a custom `ApiRequestError` class with error code, message, and status
- All functions should be async and properly typed with return types
- Include a generic `handleResponse<T>` helper for error handling
```

**5. Use your spec kit in Chat:**
- Type `/scaffold-react-app` in chat to scaffold the entire project
- Type `/react-component` to generate individual components (it will prompt you for name and description)
- Type `/api-service` to generate the complete API layer

> 🎯 **Why Spec Kit?** Prompt files turn one-off prompts into **repeatable, shareable specifications**. Your team can commit these to Git, iterate on them, and ensure consistent, high-quality AI output. This is the foundation of **specification-driven development**.

#### Additional Copilot Techniques for Frontend Development

- **Plan agent first**: Start with the **Plan** agent: *"Plan the component architecture for a voting SPA with 4 screens"*. Review the plan, then click **Start Implementation** to hand off to Agent mode
- **Vision (image context)**: Have a UI mockup or wireframe? Drag the image into the Chat view and ask: *"Build this screen as a React component"*
- **Inline Chat (`Ctrl+I`)**: Select a component in the editor and press `Ctrl+I` to ask for modifications: *"Add loading spinner and error state to this component"*
- **`/tests`**: Select a component or service file, then type `/tests` to auto-generate unit tests
- **Context with `#`**: Type `#types/index.ts` in chat to reference your TypeScript interfaces when asking Copilot to build components that use them

### Acceptance Criteria

| # | Criteria | Details |
|---|----------|---------|
| ✅ 1 | **Project setup** | A new React + TypeScript project created with Vite in `src/lunch-vote-spa/` (or your own directory), with `react-router-dom` installed |
| ✅ 2 | **Type definitions** | TypeScript interfaces defined for: `ActivePoll`, `PollOption`, `VoteRequest`, `PollResults`, `OptionResult`, `ApiError`, `VoteResponse` |
| ✅ 3 | **API service layer** | A service module that communicates with all 5 API endpoints (`POST /polls`, `GET /polls/active`, `GET /polls/{id}/results`, `POST /votes`, `GET /groups`) with proper error handling |
| ✅ 4 | **Home screen** | Users can enter a group name OR select from a list of active groups fetched from `GET /api/groups` |
| ✅ 5 | **Vote screen** | Displays the active poll question and options; users can select one option and submit their vote. Handles "no active poll" by redirecting to poll creation |
| ✅ 6 | **Create poll screen** | Users can enter a question and multiple options to create a new poll for their group |
| ✅ 7 | **Results screen** | Displays vote counts per option, percentage bars, and total votes |
| ✅ 8 | **Voter token** | Generates a unique browser token (stored in `localStorage`) to prevent duplicate voting |
| ✅ 9 | **Error handling** | API errors are displayed to the user with meaningful messages (e.g., "You've already voted") |
| ✅ 10 | **Routing** | Client-side routing works: `/` (home), `/group/:groupId` (vote), `/group/:groupId/create` (create poll), `/poll/:pollId/results` (results) |
| ✅ 11 | **Runs locally** | `npm run dev` starts the app, and it successfully communicates with the local API |
| ✅ 12 | **GitHub Copilot** | Demonstrate that GitHub Copilot assisted in building the frontend (show chat history or inline suggestions) |

### GitHub Copilot Tips for This Challenge

- Use your **Prompt Files (spec kit)** to scaffold the project, generate the API service layer, and create components consistently
- Start with the **Plan** agent to design the component architecture before implementing
- Use **Vision** by dragging mockup/wireframe images into chat for UI generation
- Use **Inline Chat** (`Ctrl+I`) to refine individual components after generation
- Ask Copilot to help with CSS styling: *"Style this component with a modern card-based layout using CSS flexbox"*
- Use `/tests` on your service layer to generate unit tests
- Use `#codebase` in your prompts so Copilot understands your project structure

---

## Challenge 3: ☁️ Liftoff! Deploy to the Cloud

### *"Ground control to Major Tom  your app is going live on Azure"*

**Duration:** ~60 minutes

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

This challenge is all about command-line work — and Copilot shines here too!

#### `@terminal` — Your Command-Line Guide

Instead of Googling Azure CLI syntax, ask Copilot directly in chat:
- `@terminal How do I deploy a zip file to Azure App Service?`
- `@terminal What's the command to list all resources in my resource group?`
- `@terminal Explain what az webapp deploy --type zip does`

#### Inline Chat in the Terminal

Press `Ctrl+I` while your cursor is in the **integrated terminal** to open Inline Chat. Describe what you want in natural language — Copilot generates the command:
- *"Publish my .NET app to a folder called publish"*  → `dotnet publish -c Release -o ./publish`
- *"Zip all files in the publish folder"* → `Compress-Archive -Path ./publish/* -DestinationPath ./publish.zip -Force`
- *"Show me the terraform outputs"* → `terraform output`

#### Error Troubleshooting

When a command fails:
1. Select the error text in the terminal
2. Right-click → **Copilot: Explain This**
3. Or use `@terminal /explain` with the error message in chat

> 💡 **Pro Tip:** After a failed command, you can click the sparkle icon ✨ next to the terminal error to have Copilot suggest a fix automatically.

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

---

## Challenge 4: 🔐 The Vault of Secrets

### *"In the cloud, secrets should never be out in the open"*

**Duration:** ~60 minutes

### Synopsis

Your app is live, but there's a problem  configuration values like connection strings and API keys are sitting in plain text in app settings. In the real world, this is a security nightmare. Enter **Azure Key Vault** and **Managed Identity**  two Azure services that work together to give your application **passwordless, secure access** to sensitive configuration.

In this challenge, you'll configure your deployed App Service to authenticate to Key Vault using its **Managed Identity** (no passwords, no keys, no secrets stored in code), store a secret in Key Vault, and have your application read it at runtime.

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

Security concepts like Managed Identity, RBAC, and Key Vault can be complex. This challenge is designed for **learning** — and the **Ask** agent is your teacher.

#### Using Ask Agent to Learn

Switch to the **Ask** agent from the dropdown (it never modifies files — safe for exploration):

- *"Explain how Azure Managed Identity works at a technical level. How does the token exchange happen?"*
- *"What's the difference between System-Assigned and User-Assigned Managed Identity?"*
- *"Why is RBAC preferred over Key Vault access policies?"*
- *"What happens when my App Service tries to access Key Vault — walk me through the authentication flow"*

#### `/explain` on Terraform Code

Select your Key Vault Terraform module and use `/explain` to understand each property:
- What does `enable_rbac_authorization = true` do?
- What is `soft_delete_retention_days` and why does it matter?
- What does the `role_definition_name = "Key Vault Secrets User"` role allow?

#### Multi-Model Exploration

Try asking the same question to **different AI models** using the model picker (click the model name at the bottom of chat). Compare how Claude, GPT, and other models explain Managed Identity differently — you'll get richer understanding from multiple perspectives!

### Acceptance Criteria

| # | Criteria | Details |
|---|----------|---------|
| ✅ 1 | **Key Vault exists** | Your Terraform-deployed Key Vault is visible in the Azure Portal with RBAC authorization enabled |
| ✅ 2 | **Managed Identity enabled** | The backend App Service has a System-Assigned Managed Identity with a valid Principal ID |
| ✅ 3 | **RBAC role assigned** | The App Service's Managed Identity has been granted the **"Key Vault Secrets User"** role on the Key Vault (via your Terraform `azurerm_role_assignment` or Azure CLI) |
| ✅ 4 | **Secret stored** | At least one secret is stored in Key Vault (e.g., a test secret or the SQL connection string). You can do this via Azure Portal or Azure CLI |
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

---

## Challenge 5: 🗃️ The Data Fortress

### *"From in-memory whispers to a fortress of persistent data"*

**Duration:** ~60 minutes

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
Server=tcp:<server>.database.windows.net,1433;Database=sqldb-lunchvote;Authentication=Active Directory Default;
```

### Your Mission

Wire up your deployed backend API to the Azure SQL Database provisioned by Terraform, using Managed Identity for passwordless authentication.

### 🤖 GitHub Copilot Skill Focus: Custom Instructions + `#codebase` Context

This challenge introduces **Custom Instructions** — always-on rules that shape every Copilot response in your workspace.

#### Step-by-Step: Create Custom Instructions

1. Create the file `.github/copilot-instructions.md` in your workspace root
2. Add rules that apply globally to all Copilot interactions:

```markdown
## Project Context
This is the Lunch Vote App — a team-based lunch voting application.
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
| ✅ 3 | **Connection string set** | The backend App Service has a connection string named `DefaultConnection` with format: `Server=tcp:<server>.database.windows.net,1433;Database=sqldb-lunchvote;Authentication=Active Directory Default;` |
| ✅ 4 | **SQL user created** | The App Service's Managed Identity is added as a user in the SQL Database with `db_datareader` and `db_datawriter` roles |
| ✅ 5 | **Schema created** | The database tables (`Poll`, `Option`, `Vote`) exist in Azure SQL (auto-created by EF Core on first request) |
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

---

## Challenge 6: 🚢 Ship It Like a Pro

### *"Production-grade deployment isn't just shipping code  it's shipping confidence"*

**Duration:** ~60 minutes

### Synopsis

Your app is deployed, secured, and connected to a real database. But is it production-ready? Not yet. Real-world applications need **zero-downtime deployments**, **rollback capabilities**, and **deployment verification** before going live. In this final challenge, you'll level up your deployment game by implementing **Blue/Green Deployment** using Azure App Service **Deployment Slots**  a feature that lets you deploy and test new versions without affecting live users.

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

#### App Service Scaling & Monitoring
Beyond deployment, you'll explore:
- **Application logging**  View real-time logs from your App Service using `az webapp log tail`
- **Health checks**  Configure App Service health checks to automatically replace unhealthy instances
- **App Service metrics**  View request count, response time, and error rates in the Azure Portal

### Your Mission

Upgrade your App Service to support deployment slots, implement a blue/green deployment workflow, and demonstrate zero-downtime releases.

### 🤖 GitHub Copilot Skill Focus: Code Review + Commit Message Generation

For the final challenge, you'll use Copilot as a **code reviewer** and **DevOps assistant** — the capstone of your Copilot journey.

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
| ✅ 1 | **Tier upgraded** | The backend API App Service Plan is upgraded to at least **Standard S1** tier (required for deployment slots). Update your Terraform and apply, or use Azure CLI |
| ✅ 2 | **Staging slot created** | A deployment slot named `staging` exists on the backend API App Service |
| ✅ 3 | **Deploy to staging** | Deploy a new version of the API to the **staging** slot (not production). The staging slot should have its own URL (e.g., `https://app-lunchvote-api-dev-xxx-staging.azurewebsites.net`) |
| ✅ 4 | **Verify staging** | Access the staging slot's Swagger UI or API endpoint and confirm it's running correctly |
| ✅ 5 | **Swap slots** | Perform a slot swap between staging and production. Verify that the production URL now serves the new version |
| ✅ 6 | **Zero downtime** | Demonstrate that the swap did not cause any downtime  the production URL remained accessible throughout the swap |
| ✅ 7 | **Rollback capability** | Perform another swap to roll back to the previous version. Verify the rollback works |
| ✅ 8 | **Live log streaming** | Use `az webapp log tail` to stream live logs from the production App Service and demonstrate you can see real-time request/response activity |
| ✅ 9 | **Terraform updated** | Your Terraform code is updated to include the staging slot configuration and the upgraded SKU |
| ✅ 10 | **GitHub Copilot** | Used GitHub Copilot to help with slot management commands, Terraform slot configuration, or understanding deployment slot concepts |

### Useful Commands

> 💡 Use GitHub Copilot to help construct and troubleshoot these commands.

```powershell
# Upgrade App Service Plan to Standard S1 (if not already via Terraform)
az appservice plan update --name <PLAN_NAME> --resource-group <RG> --sku S1

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

---

## 🎯 Final Demo Checklist

Before the final demo at 16:00, ensure you can demonstrate:

| # | Item | Status |
|---|------|--------|
| 1 | Terraform code authored with GitHub Copilot  `terraform validate` passes | ⬜ |
| 2 | React SPA built with GitHub Copilot  renders all 4 screens | ⬜ |
| 3 | Infrastructure provisioned in Azure  all resources visible in Portal | ⬜ |
| 4 | Backend API deployed and Swagger UI accessible | ⬜ |
| 5 | Frontend SPA deployed and accessible | ⬜ |
| 6 | Key Vault configured with Managed Identity access | ⬜ |
| 7 | SQL Database connected with Managed Identity (no passwords!) | ⬜ |
| 8 | Data persists across App Service restarts | ⬜ |
| 9 | Blue/Green deployment with staging slot swap demonstrated | ⬜ |
| 10 | Live log streaming shown | ⬜ |

---

## 🧹 Cleanup

After the hackathon, destroy your Azure resources to avoid ongoing charges:

```powershell
cd infra/my-terraform
terraform destroy -var="sql_admin_object_id=$OBJECT_ID" -var="sql_admin_login=$EMAIL"
```

Or delete the resource group directly:

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
| **Multi-turn conversations** | Ask follow-up questions — Copilot remembers the full conversation context |

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
| **Prompt Files (Spec Kit)** | `.github/prompts/*.prompt.md` | Reusable task specifications |
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

## 🏅 Good Luck, Hackers!

Remember  this hackathon is about **learning**, not perfection. Experiment boldly, break things, and let GitHub Copilot guide you through unfamiliar territory. The best learning happens when you're outside your comfort zone.

**Now go build something awesome!** 🚀

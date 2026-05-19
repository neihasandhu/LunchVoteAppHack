# Lunch Vote App — Azure Deployment Plan

**Status:** Awaiting Approval
**Mode:** MODIFY (existing infra in `infra/terraform`)
**IaC:** Terraform
**Subscription:** Visual Studio Enterprise Subscription (`d6240056-8859-433d-b57b-8d245ad911cf`)
**Tenant:** `c8e8c012-fca9-44ae-bd43-15a46c7500c3`
**Region:** `australiaeast`
**Resource Group:** `rg-lunchvote-nonprod`

---

## Components Detected

| Component | Path | Tech |
|---|---|---|
| API | `src/LunchVoteApi/` | .NET 10 Web API + EF Core 10 |
| SPA | `src/lunch-vote-spa/` | React 18 + Vite 5 + TS |
| Tests | `tests/LunchVoteApi.Tests/` | xUnit |
| IaC (chosen) | `infra/terraform/` | Terraform / azurerm |
| IaC (other) | `infra/bicep/` | Bicep (not used this run) |

## Target Azure Architecture

| Resource | Name (planned) | Purpose |
|---|---|---|
| Resource Group | `rg-lunchvote-nonprod` | Container |
| App Service Plan | `plan-lunchvote-nonprod-<suffix>` | Linux B1, shared by API + SPA |
| API Web App | `app-lunchvote-api-nonprod-<suffix>` | .NET runtime, System MI |
| SPA Web App | `app-lunchvote-spa-nonprod-<suffix>` | Node 20 LTS, serves Vite build |
| Azure SQL Server | `sql-lunchvote-nonprod` | Entra-only auth (no SQL login) |
| Azure SQL DB | `sqldb-lunchvote` | App database |
| Key Vault | `kv-lunchvote-nonprod` | Secrets store |
| RBAC | Key Vault Secrets User → API MI | Least-priv access |

`tfvars` already configured: `name=lunchvote`, `env=nonprod`, `sql_admin_object_id` and `sql_admin_login` set to user's Entra identity.

---

## ⚠ Risks / Items to Address Before Deploy

1. **.NET version mismatch.** `LunchVoteApi.csproj` targets `net10.0`, but the Terraform module pins App Service to `dotnet_version = "8.0"`. Linux App Service does not currently offer a stable .NET 10 stack. Options:
   - (Recommended) Retarget the API to `net8.0` for deployment, OR
   - Containerize the API and deploy as a custom container.
2. **SPA build (Oryx) skips devDependencies.** The frontend module enables `SCM_DO_BUILD_DURING_DEPLOYMENT=true` and runs Oryx, which sets `NODE_ENV=production` and skips `devDependencies` — but `vite` and `typescript` are in `devDependencies`. The `npm run build` will fail. Fix options:
   - Add `app_settings` override `"NPM_FLAGS" = "--include=dev"` (or `"npm_config_production" = "false"`), OR
   - Build the SPA locally and deploy the `dist/` folder as a zip (no Oryx build).
3. **`sqltoken.txt`** present in `src/LunchVoteApi/` — should be reviewed; do not deploy if it contains a secret. (Will be ignored in the API zip if not in publish output, but flag for cleanup.)
4. **CORS** in API points to `https://app-lunchvote-spa-${env}-${suffix}` using its OWN `random_string` — the frontend module uses a SEPARATE `random_string`, so the suffix won't match the actual SPA hostname. CORS will need to be updated after both apps are created, or refactored to share the suffix.

---

## Execution Steps (after approval)

1. **Pre-flight fixes** for risks 1, 2, 4 above (confirm choices with user).
2. `cd infra/terraform && terraform init` (already initialized; rerun safe).
3. `terraform plan -out=tfplan` — show output for review.
4. `terraform apply tfplan`.
5. Capture outputs: `api_url`, `frontend_url`, `sql_server_fqdn`, `key_vault_uri`, `resource_group_name`.
6. Run SQL user-creation script (`infra/scripts/create-sql-user.sql`) against the new DB to grant the API's managed identity `db_datareader`/`db_datawriter`.
7. Build & publish API: `dotnet publish src/LunchVoteApi -c Release -o publish/api`, zip, `az webapp deploy --src-path ...`.
8. Build SPA locally with `VITE_API_BASE_URL=<api_url>`: `npm ci && npm run build`, then deploy `dist/` zip to the SPA Web App.
9. Smoke-test: `GET <api_url>/swagger`, then open `<frontend_url>`.

## Validation / Deploy Hand-off

After plan approval and pre-flight fixes, status will be updated to `Ready for Validation` and the azure-validate skill will be invoked, followed by azure-deploy.

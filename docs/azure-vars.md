# Azure CD configuration (AKS + ACR)

This repository is Azure-first and uses:
- AKS for Kubernetes runtime
- ACR for container registry
- GitHub Actions OIDC for secure authentication (no long-lived secrets)

## Required GitHub configuration

### GitHub Secrets
- `AZURE_CLIENT_ID` — Entra App registration client ID
- `AZURE_TENANT_ID` — Entra tenant ID
- `AZURE_SUBSCRIPTION_ID` — Azure subscription ID

### GitHub Variables (Repo → Settings → Secrets and variables → Actions → Variables)
- `AZURE_ACR_NAME` — e.g. `p2acr12345` (no `.azurecr.io`)
- `AKS_RESOURCE_GROUP` — e.g. `p2-rg-dev`
- `AKS_CLUSTER_NAME` — e.g. `aks-p2-dev`

## Notes about student tenants
Some student tenants restrict App Registrations / Service Principal creation in Entra ID.
In that case, OIDC cannot be enabled until using a personal Azure subscription or
admin-provisioned identity. The workflow remains in the repo as the target CD design.

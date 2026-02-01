# Project 2 — Platform Engineering (Kubernetes + Helm)

Azure‑first platform engineering project that demonstrates a full DevOps path: build, package,
deploy, operate, and observe a containerized API on Kubernetes using Helm, health probes,
autoscaling, and real CI/CD.

The repo mirrors real platform workflows with separate dev/prod Terraform state, AKS/ACR,
OIDC‑based GitHub Actions deployments, and Azure Monitor observability.

## What’s inside
- **FastAPI service** containerized with Docker (example workload)
- **Kubernetes** deployment via **Helm chart**
- **Ingress** routing (Traefik locally)
- **Health probes** (readiness/liveness)
- **Resource limits/requests**
- **Autoscaling** via **HPA**

## Demo (local)
1) Build image
```bash
cd app
docker build -t project2-api:local .
```

Start local Kubernetes (k3d) + import image
```bash
k3d cluster create p2 --agents 1 -p "8080:80@loadbalancer"
k3d image import project2-api:local -c p2
```

Deploy with Helm
```bash
helm upgrade --install project2-api ./project2-api --namespace p2 --create-namespace
```

Verify
```bash
kubectl -n p2 get pods
kubectl -n p2 get hpa
curl http://project2.local:8080/health
```

If you use a different domain than `project2.local`, update the URL.

## Repository structure
- `app/` — FastAPI source + Dockerfile
- `project2-api/` — Helm chart (single source of truth for k8s resources)
- `docs/` — architecture + runbook
- `infra/` — Terraform (dev/prod envs)
- `.github/workflows/` — CI/CD pipelines (GitHub Actions)

## How it works (CI/CD flow)
1. Developer pushes code to GitHub  
2. **CI** builds + basic checks + Docker build  
3. **CD** (manual) builds/pushes image to **ACR** and deploys to **AKS** via **Helm**  
4. **Observability** via Azure Monitor / Log Analytics (Container Insights)

## CI/CD pipeline (job graph)
The CD workflow is split into three jobs to show a clear dependency chain in GitHub Actions:

1. `validate` — checks required Azure secrets/vars and generates a single `image_tag`
2. `build-image` — OIDC login, build + push to ACR
3. `deploy-aks` — Helm deploy using the same `image_tag`

Graph: `validate → build-image → deploy-aks`

## Environments
- `infra/terraform/envs/dev` — imported existing infra, remote state in Azure Storage
- `infra/terraform/envs/prod` — separate env with its own backend + variables

Prod quick start (after updating backend + tfvars):
```bash
cd infra/terraform/envs/prod
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

##  Project documentation
-  [Platform architecture](docs/architecture.md)  
-  [Architecture decisions](docs/decisions.md)  
-  Kubernetes manifests and Helm charts in `/k8s` and `/project2-api`  
-  Terraform infrastructure in `/infra/terraform`  
-  CI/CD workflows in `/.github/workflows`

##  Architecture diagram
See the rendered diagram in `docs/architecture.md` (Mermaid).

##  Azure deployment (AKS + ACR)
This project is Azure-first and targets deployment to AKS with images stored in ACR.
CD is implemented as a GitHub Actions workflow using OIDC (federated identity) and Helm releases.
Configuration reference: `docs/azure-vars.md`.

##  Security model
- Identity-based authentication (OIDC) for CI/CD  
- No long-lived secrets in pipelines  
- Azure RBAC and least-privilege access  
- Infrastructure defined and reviewed as code  

## Observability (Azure Monitor)
Container Insights is enabled and logs flow to Log Analytics (dev and prod).

KQL example:
```kql
KubePodInventory
| where ClusterName == "aks-p2-dev"
| summarize count() by Namespace
```

## Runbook (short)
- **Deploy:** Run GitHub Actions → `CD (Azure AKS)` (workflow_dispatch)  
- **Rollback:** `helm -n p2-dev history project2-api` → `helm -n p2-dev rollback project2-api <REV>`  
- **Troubleshoot:** `kubectl -n p2-dev get pods` + `kubectl -n p2-dev logs deploy/project2-api`

## Cost (quick notes)
- AKS: dev 1 node, prod 2 nodes  
- ACR: Basic SKU  
- Log Analytics: 30‑day retention  
- Clean up RGs when done to avoid charges

## Prerequisites (local)
- Docker
- k3d
- kubectl
- helm
- macOS: ability to edit `/etc/hosts` (for local domain)

Install tools (Homebrew):
```bash
brew install k3d kubectl helm
```

This local setup simulates a real platform environment using a lightweight Kubernetes
distribution (k3d) and the same Helm chart used in AKS.

```bash
Run locally (k3d + Helm)
1) Build the image
cd app
docker build -t project2-api:local .
cd ..

2) Create cluster with ingress port mapping
k3d cluster create p2 --agents 1 -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"
k3d image import project2-api:local -c p2

3) Local DNS entry
sudo sh -c 'echo "127.0.0.1 project2.local" >> /etc/hosts'

4) Deploy with Helm
helm upgrade --install project2-api ./project2-api --namespace p2 --create-namespace

5) Test

http://project2.local:8080/health

http://project2.local:8080/docs

Verify autoscaling
kubectl -n p2 get hpa
```

## Operational notes

- The Helm chart is the single source of truth for Kubernetes resources.
- The platform is designed to separate application concerns from platform and infrastructure concerns.

- Local ingress is handled by Traefik shipped with k3d/k3s.

Roadmap
See ROADMAP.md.

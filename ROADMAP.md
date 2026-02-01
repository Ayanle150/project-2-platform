# Project scope — Platform / DevOps

## Phase 1 — Local foundation
- [x] Repo structure
- [x] Minimal API (FastAPI)
- [x] Docker build + run
- [x] Local Kubernetes (k3d) deployment

## Phase 2 — Infrastructure as Code (Terraform)
- [x] Remote state
- [x] Network baseline (VNet, subnets, ingress)
- [x] ACR module
- [x] AKS module
- [x] Environment separation (dev/stage/prod)

## Phase 3 — Kubernetes platform
- [x] Helm chart for application
- [x] Ingress routing
- [x] Resource limits and probes
- [x] Autoscaling (HPA)
- [x] Namespace strategy
- [x] ConfigMaps and Secrets

## Phase 4 — CI/CD
- [x] Build and test pipelines
- [x] Docker image workflow
- [x] OIDC GitHub → Azure authentication
- [x] Build and push to ACR
- [x] Deploy to AKS (Helm)
- [x] Rollback strategy

## Phase 5 — Security & operations
- [x] RBAC and least privilege
- [x] Secrets management improvements
- [x] Basic observability (logs/metrics)
- [x] Runbook and troubleshooting guide

## Phase 6 — Portfolio packaging
- [x] Architecture documentation
- [x] Final architecture diagram
- [x] Screenshots and demo steps
- [x] Interview talking points

# Project 2 — Platform Engineering (Kubernetes + Helm)

Production-style platform engineering project demonstrating how to build, run, and operate
a containerized API on Kubernetes using Helm, ingress routing, health probes, resource
governance, and autoscaling.

The repository is structured to mirror real-world platform and DevOps workflows, and is
designed to evolve into a full cloud platform on Azure (AKS) provisioned with Terraform and
automated CI/CD.

## What’s inside
- **FastAPI service** containerized with Docker (example workload)
- **Kubernetes** deployment via **Helm chart**
- **Ingress** routing (Traefik locally)
- **Health probes** (readiness/liveness)
- **Resource limits/requests**
- **Autoscaling** via **HPA**
- *(Next)* Terraform provisioning + GitHub Actions CI/CD to AKS

## Repository structure
- `app/` — FastAPI source + Dockerfile
- `project2-api/` — Helm chart (single source of truth for k8s resources)
- `docs/` — architecture + runbook (WIP)
- `infra/` — Terraform (WIP)
- `.github/workflows/` — CI/CD pipelines (GitHub Actions)

##  Project documentation
-  [Platform architecture](docs/architecture.md)  
-  [Architecture decisions](docs/decisions.md)  
-  Kubernetes manifests and Helm charts in `/k8s` and `/project2-api`  
-  Terraform infrastructure in `/infra/terraform`  
-  CI/CD workflows in `/.github/workflows`

##  Architecture diagram
See the rendered diagram in `docs/architecture.md` (Mermaid).

##  Platform maturity
This repository is structured as a real platform engineering project.

Implemented:
- CI pipelines (build + docker)
- Containerized application
- Terraform AKS foundation
- Helm charts and ingress manifests
- Architecture documentation

In progress / planned:
- OIDC GitHub → Azure authentication
- ACR integration
- Automated deployments
- Observability and secrets management

##  Azure deployment (AKS + ACR)
This project is Azure-first and targets deployment to AKS with images stored in ACR.
CD is implemented as a GitHub Actions workflow using OIDC (federated identity) and Helm releases.

Due to restricted permissions in the student tenant (App registration / SP creation),
the Azure CD workflow is gated until the required identity configuration is available.
The repository includes the full target workflow and required configuration under
`docs/azure-vars.md`.

##  Security model
- Identity-based authentication (OIDC) for CI/CD  
- No long-lived secrets in pipelines  
- Azure RBAC and least-privilege access  
- Infrastructure defined and reviewed as code  

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
distribution (k3d) and the same Helm chart that will later be used in AKS.

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

Next steps will add: Terraform remote state, AKS provisioning, container registry, and CI/CD deploy.

Roadmap

See ROADMAP.md.

# Project overview — Platform / DevOps

This repository delivers a complete Azure-first platform engineering stack that demonstrates
the end-to-end workflow for building, packaging, deploying, and operating a containerized API
on Kubernetes with Helm and CI/CD.

## Scope
- Local developer workflow with Docker and k3d
- Infrastructure as code using Terraform (separate dev/prod environments)
- AKS + ACR delivery pipeline with GitHub Actions OIDC
- Helm-based application release with ingress, probes, and autoscaling
- Security and operations foundations (RBAC, secrets handling, observability, runbook)

## Key deliverables
- Terraform environments for AKS, ACR, networking, and remote state
- CI/CD pipelines for build, push to ACR, and Helm deploys to AKS
- Helm chart as the single source of truth for Kubernetes resources
- Documented architecture, ADRs, and operational guidance

## Evidence in this repo
- `infra/terraform/` — environment-specific Terraform
- `.github/workflows/` — CI/CD workflows with OIDC
- `project2-api/` — Helm chart
- `docs/` — architecture, decisions, and runbook

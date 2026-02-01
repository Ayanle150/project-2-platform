# Architecture decisions

This document captures key engineering decisions for the DevOps Platform Stack project.

## ADR-001: Use GitHub Actions for CI/CD
**Decision:** Use GitHub Actions as the CI/CD engine for builds, tests and delivery workflows.  
**Rationale:** Tight integration with the repository, simple audit trail, and strong ecosystem for Docker/Kubernetes workflows.  
**Status:** Implemented (CI + Docker build workflows).

## ADR-002: Containerize the application with Docker
**Decision:** Package the API as a Docker image and standardize build steps.  
**Rationale:** Reproducible builds, consistent runtime across environments, and a clean handoff to Kubernetes.  
**Status:** Implemented (Dockerfile + CI Docker build).

## ADR-003: Target AKS for orchestration
**Decision:** Use Azure Kubernetes Service (AKS) as the target runtime for workloads.  
**Rationale:** Managed control plane, Azure-native integration (ACR, RBAC), and production-relevant deployment patterns.  
**Status:** Implemented (AKS target confirmed and deployment artifacts in place).

## ADR-004: Provision infrastructure with Terraform
**Decision:** Use Terraform for infrastructure as code.  
**Rationale:** Reproducible infra, version control, modularity, and environment separation (dev/stage/prod).  
**Status:** Implemented (Terraform modules and environments committed).

## ADR-005: Prefer OIDC over long-lived secrets for CI authentication
**Decision:** Use GitHub Actions OIDC (federated credentials) for Azure authentication.  
**Rationale:** Eliminates long-lived secrets, reduces blast radius, aligns with enterprise best practices.  
**Status:** Implemented (OIDC authentication configured for CI).

## ADR-006: Use Helm for application release configuration
**Decision:** Maintain a Helm chart for the application (service + ingress + values).  
**Rationale:** Environment-specific configuration, repeatable releases, cleaner Kubernetes manifests.  
**Status:** Implemented (Helm chart templates and values in place).

## ADR-007: Ingress as the entry point
**Decision:** Use an ingress resource/controller to expose services externally.  
**Rationale:** Standard Kubernetes routing, TLS termination, and future readiness for multiple services/domains.  
**Status:** Implemented (ingress routing and TLS strategy defined).

## ADR-008: Gate Azure CD due to restricted student tenant (Entra ID permissions)
**Decision:** Keep the target Azure CD workflow (OIDC → ACR → AKS) in the repository, but gate execution until required Entra ID permissions are available.  
**Rationale:** Some student tenants restrict App Registrations / Service Principal creation, preventing OIDC configuration. Gating avoids blocking development while preserving an Azure-first architecture and deployment design.  
**Status:** Implemented (OIDC → ACR → AKS workflow active).

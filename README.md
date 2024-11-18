# Cloud Native Application with AKS, Istio, and ArgoCD

This repository contains a complete cloud-native application setup demonstrating modern DevOps practices including Infrastructure as Code, CI/CD, GitOps, and service mesh implementation.

## Components

1. **Go Application**
   - Simple HTTP server responding with "Hello, World!"
   - Containerized using Docker
   - Located in `main.go` and `Dockerfile`

2. **Infrastructure (Terraform)**
   - AKS cluster provisioning
   - Azure Container Registry (ACR) setup
   - Located in `terraform/` directory

3. **Kubernetes Manifests**
   - Base configurations in `k8s/base/`
   - Environment-specific overlays in `k8s/overlays/`
   - Kustomize for environment management

4. **Service Mesh (Istio)**
   - Gateway and VirtualService configurations
   - Canary deployment setup
   - Located in `istio/` directory

5. **CI/CD Pipeline**
   - GitHub Actions workflow for CI
   - ArgoCD for GitOps-based deployments
   - Located in `.github/workflows/`

## Prerequisites

- Azure subscription
- Azure CLI
- Terraform
- kubectl
- Helm
- Docker

## Setup Instructions

1. **Infrastructure Setup**
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

2. **Connect to AKS**
   ```bash
   az aks get-credentials --resource-group <resource-group> --name <cluster-name>
   ```

3. **Install Istio**
   ```bash
   istioctl install --set profile=demo
   ```

4. **Install ArgoCD**
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

5. **Deploy Application**
   ```bash
   kubectl apply -k k8s/overlays/prod
   ```

## Architecture

The application follows a modern cloud-native architecture:

- **Infrastructure Layer**: Managed through Terraform
- **Container Orchestration**: Kubernetes (AKS)
- **Service Mesh**: Istio for traffic management
- **Continuous Deployment**: ArgoCD following GitOps principles
- **Container Registry**: Azure Container Registry (ACR)

## Environment Management

The application supports multiple environments through Kustomize overlays:
- SIT (System Integration Testing)
- UAT (User Acceptance Testing)
- PROD (Production)

Each environment has its own configuration in `k8s/overlays/`.

## CI/CD Pipeline

1. **CI Process (GitHub Actions)**
   - Builds Go application
   - Runs tests
   - Builds Docker image
   - Pushes to ACR

2. **CD Process (ArgoCD)**
   - Monitors Git repository for changes
   - Automatically syncs Kubernetes manifests
   - Supports progressive delivery through Istio

## Traffic Management

Istio provides advanced traffic management capabilities:
- Canary deployments
- A/B testing
- Traffic splitting
- Load balancing

## Monitoring and Observability

The setup includes:
- Prometheus for metrics
- Grafana for visualization
- Jaeger for distributed tracing
- Kiali for service mesh visualization

## Security Considerations

- RBAC enabled on AKS cluster
- Network policies implemented
- Istio mTLS enabled
- Secrets management through Azure Key Vault

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License
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

## Running the Hello World Application

You can run the application in three different ways:

1. **Run Locally Without Docker**
   ```bash
   # Run directly with Go
   go run main.go
   
   # Test the application
   curl http://localhost:8080
   # Should output: Hello, World!
   ```

2. **Run with Docker**
   ```bash
   # Build the Docker image
   docker build -t hello-app .
   
   # Run the container
   docker run -p 8080:8080 hello-app
   
   # Test the application
   curl http://localhost:8080
   # Should output: Hello, World!
   ```

3. **Run on Kubernetes (with ArgoCD)**
   
   First, make sure you have:
   - Updated the repository URL in `k8s/argocd/application.yaml`
   - Pushed your code to GitHub
   - ArgoCD is installed and configured (see ArgoCD Setup section)

   Then apply the ArgoCD configuration:
   ```bash
   # Apply ArgoCD configurations
   kubectl apply -f k8s/argocd/project.yaml
   kubectl apply -f k8s/argocd/application.yaml
   
   # Wait for the application to be deployed
   kubectl wait --for=condition=available deployment/hello-app -n devops --timeout=300s
   
   # Port forward to access the application
   kubectl port-forward svc/hello-app -n devops 8080:8080
   
   # Test the application
   curl http://localhost:8080
   # Should output: Hello, World!
   ```

   You can also monitor the deployment in the ArgoCD UI:
   1. Open http://localhost:8080 (after port-forwarding ArgoCD)
   2. Log in to ArgoCD
   3. You should see your application deployment status

## ArgoCD Setup and Configuration

1. **Install ArgoCD**
   ```bash
   # Create ArgoCD namespace
   kubectl create namespace argocd
   
   # Install ArgoCD
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   
   # Wait for ArgoCD pods to be ready
   kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s
   ```

2. **Access ArgoCD UI**
   ```bash
   # Port forward to access ArgoCD UI
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   
   # Get the initial admin password
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```
   Then access ArgoCD UI at: http://localhost:8080
   Default username: admin

3. **Deploy Application Using ArgoCD**
   
   The repository includes ArgoCD configuration files in `k8s/argocd/`:
   - `application.yaml`: Defines the application deployment configuration
   - `project.yaml`: Defines project-level settings and permissions

   Apply the configurations:
   ```bash
   # Apply the project configuration
   kubectl apply -f k8s/argocd/project.yaml
   
   # Apply the application configuration
   kubectl apply -f k8s/argocd/application.yaml
   ```

   Note: Make sure to update the repository URL in `application.yaml` to match your GitHub repository.

4. **Verify Deployment**
   ```bash
   # Check ArgoCD application status
   kubectl get applications -n argocd
   
   # Check deployed resources
   kubectl get all -n devops
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License# dev

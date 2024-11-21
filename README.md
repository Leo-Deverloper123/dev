# DevOps Project with AKS, ArgoCD, and Istio

This project demonstrates a complete DevOps pipeline using Azure Kubernetes Service (AKS), ArgoCD, and Istio service mesh.

## Project Structure

```
DevOps/
├── .github/workflows/    # CI Pipeline
├── terraform/           # Infrastructure as Code
├── k8s/                # Kubernetes Manifests
│   ├── base/           # Base Configurations
│   ├── environments/   # Environment-specific Configs
│   └── argocd/        # ArgoCD Configurations
├── istio/              # Istio Configurations
└── src/               # Application Source Code
```

## Prerequisites

- Azure Subscription
- Azure CLI
- Terraform
- kubectl
- ArgoCD CLI
- Go 1.21+
- Docker

## Infrastructure Setup

1. **Initialize Terraform**:
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

2. **Configure kubectl**:
```bash
az aks get-credentials --resource-group <resource-group> --name <cluster-name>
```

3. **Install ArgoCD**:
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Application Deployment

1. **Build and Test Application**:
```bash
go test ./...
go build -v ./...
```

2. **Configure GitHub Secrets**:
Required secrets:
- AZURE_CREDENTIALS
- ACR_LOGIN_SERVER
- ACR_USERNAME
- ACR_PASSWORD

3. **Deploy ArgoCD Applications**:
```bash
kubectl apply -f k8s/argocd/project.yaml
kubectl apply -f k8s/argocd/root-app.yaml
```

## Environment Setup

The project supports three environments:
- SIT (System Integration Testing)
- UAT (User Acceptance Testing)
- PROD (Production)

Each environment is managed through Kustomize overlays.

## Traffic Management

Istio configurations include:
- Gateway for ingress traffic
- VirtualService for traffic routing (90/10 split for canary)
- DestinationRule for version management

## Monitoring and Access

1. **Access ArgoCD UI**:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

2. **Access Application**:
```bash
kubectl port-forward svc/hello-world -n <environment> 8080:80
```

## Security Features

- Non-root container execution
- Network policies
- Resource limits
- RBAC configurations
- Workload Identity

## CI/CD Pipeline

The GitHub Actions pipeline:
1. Builds Go application
2. Runs tests
3. Builds Docker image
4. Pushes to ACR
5. Updates deployment manifests
6. Triggers ArgoCD sync

## Development Workflow

1. Make code changes
2. Push to GitHub
3. CI pipeline builds and pushes new image
4. Updates manifests with new image tag
5. ArgoCD detects changes and syncs
6. Istio manages traffic routing

## Troubleshooting

1. **Check Application Logs**:
```bash
kubectl logs -n <namespace> -l app=hello-world
```

2. **Check ArgoCD Status**:
```bash
kubectl get applications -n argocd
argocd app get devops-app
```

3. **Verify Istio**:
```bash
kubectl get virtualservices,destinationrules -n <namespace>
```

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Create pull request

## License

MIT License

## Contact

For questions or support, please open an issue in the repository.

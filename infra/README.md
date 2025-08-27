# Infrastructure

This directory contains infrastructure as code (IaC) configurations for deploying the EDI Project.

## Structure

```
infra/
├── docker/          # Dockerfiles and configurations
├── kubernetes/      # Kubernetes manifests
├── terraform/       # Terraform configurations
├── helm/           # Helm charts
├── nginx/          # NGINX configurations
├── monitoring/     # Monitoring configurations
└── scripts/        # Deployment scripts
```

## Technologies

- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **Infrastructure**: Terraform
- **Package Management**: Helm
- **Load Balancing**: NGINX
- **Monitoring**: Prometheus + Grafana

## Getting Started

### Local Development
```bash
# Start services with Docker Compose
docker-compose up -d

# Stop services
docker-compose down
```

### Production Deployment
```bash
# Deploy with Kubernetes
kubectl apply -f kubernetes/

# Deploy with Helm
helm install edi-project ./helm/edi-project
```

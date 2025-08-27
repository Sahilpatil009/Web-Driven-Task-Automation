# Deployment Guide

This guide covers deployment strategies for the EDI Project across different environments.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Setup](#environment-setup)
- [Local Development](#local-development)
- [Staging Deployment](#staging-deployment)
- [Production Deployment](#production-deployment)
- [Monitoring & Observability](#monitoring--observability)
- [Troubleshooting](#troubleshooting)

## 🛠 Prerequisites

### Development
- Node.js 18+
- Docker & Docker Compose
- Git

### Production
- Kubernetes cluster (v1.24+)
- PostgreSQL 15+ (managed service recommended)
- Redis 7+ (managed service recommended)
- Container registry access
- SSL certificates

## 🌍 Environment Setup

### Environment Variables

Create appropriate `.env` files for each environment:

#### Development (`.env`)
```bash
NODE_ENV=development
DATABASE_URL=postgresql://postgres:password@localhost:5432/edi_dev
REDIS_URL=redis://localhost:6379
JWT_SECRET=dev-secret-key
API_PORT=8000
FRONTEND_PORT=3000
LOG_LEVEL=debug
```

#### Staging (`.env.staging`)
```bash
NODE_ENV=staging
DATABASE_URL=postgresql://user:pass@staging-db:5432/edi_staging
REDIS_URL=redis://staging-redis:6379
JWT_SECRET=${STAGING_JWT_SECRET}
API_PORT=8000
FRONTEND_PORT=3000
LOG_LEVEL=info
```

#### Production (`.env.production`)
```bash
NODE_ENV=production
DATABASE_URL=${PRODUCTION_DATABASE_URL}
REDIS_URL=${PRODUCTION_REDIS_URL}
JWT_SECRET=${PRODUCTION_JWT_SECRET}
API_PORT=8000
FRONTEND_PORT=3000
LOG_LEVEL=warn
```

## 🖥 Local Development

### Quick Start
```bash
# Clone and setup
git clone <repository-url>
cd edi-project
npm run setup  # or scripts/setup.sh on Unix systems

# Start development
npm run dev
```

### Individual Services
```bash
# Frontend only
cd frontend && npm run dev

# Backend only
cd backend && npm run dev

# CLI development
cd cli && npm run dev
```

### Database Operations
```bash
# Start database services
docker-compose up -d postgres redis

# Run migrations (when available)
cd backend && npm run migrate

# Seed development data
cd backend && npm run seed:dev
```

## 🧪 Staging Deployment

### Docker Deployment
```bash
# Build images
docker-compose -f docker-compose.staging.yml build

# Deploy to staging
docker-compose -f docker-compose.staging.yml up -d

# Check deployment
docker-compose -f docker-compose.staging.yml ps
```

### Kubernetes Deployment
```bash
# Apply configurations
kubectl apply -f infra/kubernetes/namespace.yml
kubectl apply -f infra/kubernetes/staging/

# Check deployment status
kubectl get pods -n edi-staging
kubectl get services -n edi-staging

# View logs
kubectl logs -f deployment/edi-backend -n edi-staging
```

## 🚀 Production Deployment

### Pre-deployment Checklist
- [ ] Environment variables configured
- [ ] SSL certificates installed
- [ ] Database backups verified
- [ ] Monitoring systems ready
- [ ] Health checks configured
- [ ] Security scanning completed

### Blue-Green Deployment
```bash
# 1. Deploy to green environment
kubectl apply -f infra/kubernetes/production/green/

# 2. Verify green deployment
kubectl get pods -n edi-production-green
./scripts/health-check.sh green

# 3. Switch traffic (update service selector)
kubectl patch service edi-frontend -n edi-production \
  -p '{"spec":{"selector":{"version":"green"}}}'

# 4. Monitor and verify
./scripts/monitor-deployment.sh

# 5. Scale down blue environment (after verification)
kubectl scale deployment edi-backend-blue --replicas=0 -n edi-production
```

### Rolling Deployment
```bash
# Update images and deploy
kubectl set image deployment/edi-backend \
  backend=ghcr.io/yourorg/edi-backend:v1.2.0 \
  -n edi-production

# Monitor rollout
kubectl rollout status deployment/edi-backend -n edi-production

# Rollback if needed
kubectl rollout undo deployment/edi-backend -n edi-production
```

### Helm Deployment
```bash
# Install/upgrade with Helm
helm upgrade --install edi-project ./infra/helm/edi-project \
  --namespace edi-production \
  --values infra/helm/values.production.yml \
  --wait --timeout=10m

# Check status
helm status edi-project -n edi-production
```

## 📊 Monitoring & Observability

### Health Checks
```bash
# Application health
curl -f http://localhost:8000/health
curl -f http://localhost:3000/api/health

# Database connectivity
curl -f http://localhost:8000/health/db

# External dependencies
curl -f http://localhost:8000/health/dependencies
```

### Metrics Collection
```bash
# Start monitoring stack
docker-compose --profile monitoring up -d

# Access dashboards
# Grafana: http://localhost:3001 (admin/admin)
# Prometheus: http://localhost:9090
```

### Log Aggregation
```bash
# View aggregated logs
docker-compose logs -f backend frontend

# In Kubernetes
kubectl logs -f -l app=edi-backend -n edi-production --tail=100
```

## 🔧 Infrastructure as Code

### Terraform Deployment
```bash
cd infra/terraform

# Initialize Terraform
terraform init

# Plan infrastructure changes
terraform plan -var-file="environments/production.tfvars"

# Apply changes
terraform apply -var-file="environments/production.tfvars"
```

### Environment Provisioning
```bash
# Create new environment
./scripts/provision-environment.sh staging

# Destroy environment
./scripts/destroy-environment.sh staging
```

## 🔒 Security Considerations

### SSL/TLS Configuration
```bash
# Generate certificates (Let's Encrypt)
certbot certonly --dns-cloudflare \
  --dns-cloudflare-credentials ~/.secrets/cloudflare.ini \
  -d edi-project.com -d api.edi-project.com

# Update Kubernetes secrets
kubectl create secret tls edi-tls \
  --cert=fullchain.pem \
  --key=privkey.pem \
  -n edi-production
```

### Secrets Management
```bash
# Create Kubernetes secrets
kubectl create secret generic edi-secrets \
  --from-literal=jwt-secret=$JWT_SECRET \
  --from-literal=db-password=$DB_PASSWORD \
  -n edi-production

# Using sealed-secrets (recommended)
echo -n $JWT_SECRET | kubectl create secret generic edi-jwt \
  --dry-run=client --from-file=jwt-secret=/dev/stdin -o yaml | \
  kubeseal -o yaml > edi-jwt-sealed.yaml
```

## 🚨 Troubleshooting

### Common Issues

#### Application Won't Start
```bash
# Check logs
docker-compose logs backend
kubectl logs deployment/edi-backend -n edi-production

# Check environment variables
docker-compose exec backend env | grep -E "(DATABASE_URL|REDIS_URL)"

# Test database connectivity
docker-compose exec backend npm run db:test
```

#### Database Connection Issues
```bash
# Test database connection
docker-compose exec postgres psql -U postgres -d edi_dev -c "SELECT 1"

# Check database migrations
cd backend && npm run migrate:status

# Reset database (development only)
cd backend && npm run db:reset
```

#### Performance Issues
```bash
# Check resource usage
docker stats
kubectl top pods -n edi-production

# Database performance
docker-compose exec postgres pg_stat_activity

# Check Redis memory usage
docker-compose exec redis redis-cli info memory
```

### Emergency Procedures

#### Service Recovery
```bash
# Restart services
docker-compose restart backend frontend
kubectl rollout restart deployment/edi-backend -n edi-production

# Scale services
kubectl scale deployment edi-backend --replicas=5 -n edi-production
```

#### Database Recovery
```bash
# Restore from backup
pg_restore -h localhost -U postgres -d edi_production latest_backup.dump

# Point-in-time recovery (if supported)
# Follow your cloud provider's documentation
```

## 📈 Performance Optimization

### Database Optimization
```sql
-- Add indexes for better performance
CREATE INDEX CONCURRENTLY idx_users_email ON users(email);
CREATE INDEX CONCURRENTLY idx_transactions_created_at ON transactions(created_at);

-- Analyze query performance
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'user@example.com';
```

### Application Optimization
```bash
# Enable gzip compression
# Update nginx configuration

# Optimize Docker images
docker build --target production -t edi-backend:optimized .

# Configure resource limits
kubectl patch deployment edi-backend -p '{"spec":{"template":{"spec":{"containers":[{"name":"backend","resources":{"limits":{"cpu":"1000m","memory":"1Gi"}}}]}}}}'
```

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [PostgreSQL Performance Tuning](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [NGINX Configuration](https://nginx.org/en/docs/)

---

For additional support, please refer to the [troubleshooting guide](troubleshooting.md) or contact the DevOps team.

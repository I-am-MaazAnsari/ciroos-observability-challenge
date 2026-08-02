# Ciroos Observability Challenge

## Overview

This project demonstrates a production-inspired Kubernetes observability environment on AWS using Infrastructure as Code and GitOps principles.

## Technologies

- Terraform
- Amazon EKS
- Kubernetes
- Argo CD
- GitHub
- Prometheus
- Grafana
- NGINX

## Architecture

GitHub
      │
      ▼
 Argo CD (GitOps)
      │
      ▼
 Amazon EKS
      │
      ▼
 NGINX Application
      │
      ▼
 Prometheus
      │
      ▼
 Grafana

## Architecture Diagram

![Architecture Diagram](docs/architecture.drawio.png)

## Features

- Infrastructure provisioned using Terraform
- Kubernetes application deployment
- GitOps continuous deployment with Argo CD
- Automatic synchronization from GitHub
- Prometheus metrics collection
- Grafana dashboards
- Declarative Kubernetes manifests

## Repository Structure

```
apps/
  nginx/

terraform/
  modules/
    network/
    eks/

README.md
high-level-architecture.md
repository-folder-structure.md
```

## Deployment Workflow

1. Provision AWS infrastructure using Terraform
2. Deploy EKS cluster
3. Install Argo CD
4. Connect GitHub repository
5. Deploy NGINX application
6. Install kube-prometheus-stack
7. Monitor application using Prometheus and Grafana

## Validation

- Application successfully deployed through Argo CD
- Auto Sync enabled
- GitOps workflow verified
- Prometheus targets healthy
- Grafana dashboards operational

## Future Improvements

- Loki for centralized logging
- Alertmanager
- Multi-region deployment
- AWS ALB Ingress Controller
- WAF integration
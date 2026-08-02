# High-Level Architecture

## Overview

This project demonstrates a GitOps-based Kubernetes deployment on Amazon EKS using Terraform, Argo CD, Prometheus, and Grafana.

The infrastructure is provisioned with Terraform. Argo CD continuously synchronizes Kubernetes manifests from GitHub, while Prometheus and Grafana provide monitoring and visualization.

---

## Architecture

```
                GitHub Repository
                       │
             Git Push (GitOps)
                       │
                 Argo CD watches
                       │
                       ▼
              Amazon EKS Cluster
        ┌───────────────────────────┐
        │                           │
        │   NGINX Deployment         │
        │   Kubernetes Service       │
        │                           │
        └─────────────┬─────────────┘
                      │
                      ▼
              Prometheus Server
                      │
                      ▼
                 Grafana Dashboard
```

---

## Components

### Terraform

- Creates AWS infrastructure
- Provisions networking
- Deploys Amazon EKS

### Amazon EKS

- Hosts Kubernetes workloads
- Runs Argo CD
- Runs Prometheus and Grafana

### Argo CD

- Watches GitHub repository
- Automatically synchronizes manifests
- Self-heals configuration drift

### GitHub

Stores Kubernetes manifests inside:

```
apps/nginx
```

Every Git push automatically updates Kubernetes.

### Prometheus

Collects:

- Cluster metrics
- Node metrics
- Pod metrics
- Kubernetes metrics

### Grafana

Visualizes Prometheus metrics using dashboards.

---

## GitOps Workflow

Developer

↓

Git Commit

↓

Git Push

↓

GitHub Repository

↓

Argo CD detects change

↓

Sync to Kubernetes

↓

Deployment Updated

↓

Prometheus collects metrics

↓

Grafana visualizes metrics

---

## Project Outcome

This project demonstrates:

- Infrastructure as Code using Terraform
- Kubernetes on Amazon EKS
- GitOps with Argo CD
- Automated application deployment
- Prometheus monitoring
- Grafana dashboards
- Continuous synchronization from GitHub
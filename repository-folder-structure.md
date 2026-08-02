# Repository Folder Structure

```
ciroos-observability-challenge
│
├── apps
│   └── nginx
│       ├── deployment.yaml
│       ├── service.yaml
│       └── namespace.yaml
│
├── terraform
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   │
│   └── modules
│       ├── network
│       └── eks
│
├── README.md
├── high-level-architecture.md
├── repository-folder-structure.md
└── .gitignore
```

---

## Folder Description

### apps/

Contains Kubernetes manifests managed by Argo CD.

```
apps/nginx
```

Includes:

- Namespace
- Deployment
- Service

---

### terraform/

Infrastructure as Code.

Responsible for:

- AWS networking
- Amazon EKS
- Terraform modules

---

### modules/

Reusable Terraform modules.

Current modules:

- network
- eks

---

### README.md

Project overview and setup guide.

---

### high-level-architecture.md

Architecture documentation.

---

### repository-folder-structure.md

Repository organization and folder explanations.

---

## GitOps Flow

GitHub

↓

Argo CD

↓

Amazon EKS

↓

NGINX Deployment

---

## Monitoring Flow

Kubernetes

↓

Prometheus

↓

Grafana

---

## Current Features

- Terraform Infrastructure
- Amazon EKS
- Kubernetes
- GitOps using Argo CD
- Prometheus Monitoring
- Grafana Dashboards
- Automatic Deployment Sync
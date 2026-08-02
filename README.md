# Ciroos Observability Challenge

## Overview
Production-quality AWS observability environment for interview assignment.

## Architecture
- Two Amazon EKS clusters across two AWS regions
- Private communication between services using VPC Peering
- AWS ALB with WAF protection
- Infrastructure as Code using Terraform
- Kubernetes deployments with Helm-based observability stack
- Prometheus, Grafana, Loki, and Alerting
- Python verification tool
- Fault injection capabilities
- Root Cause Analysis documentation

## Quick Start
1. Clone repository
2. Review architecture in `docs/architecture.md`
3. Follow implementation plan in `docs/implementation-plan.md`

## Directory Structure
```
ciroos-observability-challenge/
├── README.md
├── .gitignore
├── docs/
│   ├── architecture.md
│   ├── implementation-plan.md
│
├── terraform/
│   ├── modules/
│   │   ├── network/
│   │   ├── eks/
│   │   ├── alb/
│   │   ├── waf/
│   │
│   ├── environments/
│   │   ├── us-east-1/
│   │   └── us-west-2/
│   │
│   └── backend/
│
├── kubernetes/
│   ├── frontend/
│   ├── inventory/
│   ├── ingress/
│
├── observability/
│   ├── prometheus/
│   ├── grafana/
│   ├── loki/
│   └── alerts/
│
├── python/
│   └── verification/
│
├── faults/
│
├── rca/
│
└── screenshots/
```

## Prerequisites
- AWS Account with appropriate permissions
- Terraform v1.5+
- kubectl
- Helm
- Python 3.9+

## Next Steps
Refer to the implementation plan for detailed setup instructions.
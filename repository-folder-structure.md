# Repository Folder Structure

## Overview
This document defines the organized folder structure for the interview assignment repository. The structure follows DevOps best practices and separates concerns for Infrastructure as Code, Kubernetes manifests, observability, and verification tools.

## Root Directory Structure

```
ciroos-observability-challenge/
├── README.md                          # Project overview and setup instructions
├── LICENSE                            # Open source license (MIT/Apache 2.0)
├── .gitignore                         # Git ignore patterns
├── .editorconfig                      # Editor configuration
├── .pre-commit-config.yaml            # Pre-commit hooks for code quality
│
├── docs/                              # Documentation
│   ├── architecture/                  # Architecture diagrams and decisions
│   ├── api/                           # API documentation
│   ├── troubleshooting/               # Troubleshooting guides
│   └── rca/                           # Root Cause Analysis templates
│
├── infrastructure/                     # Terraform Infrastructure as Code
│   ├── modules/                       # Reusable Terraform modules
│   │   ├── vpc/                       # VPC module
│   │   ├── eks/                       # EKS cluster module
│   │   ├── networking/                # Networking components module
│   │   ├── security/                  # Security groups, WAF, IAM
│   │   └── observability/             # Observability infrastructure
│   │
│   ├── environments/                  # Environment-specific configurations
│   │   ├── dev/                       # Development environment
│   │   │   ├── main.tf                # Main Terraform configuration
│   │   │   ├── variables.tf           # Environment variables
│   │   │   ├── terraform.tfvars       # Variable values
│   │   │   └── outputs.tf             # Output definitions
│   │   │
│   │   └── prod/                      # Production-like environment
│   │       ├── us-east-1/             # Primary region
│   │       │   ├── main.tf
│   │       │   ├── variables.tf
│   │       │   └── terraform.tfvars
│   │       └── us-west-2/             # Secondary region
│   │           ├── main.tf
│   │           ├── variables.tf
│   │           └── terraform.tfvars
│   │
│   ├── scripts/                       # Infrastructure helper scripts
│   │   ├── init.sh                    # Terraform initialization
│   │   ├── plan.sh                    # Terraform planning
│   │   ├── apply.sh                   # Terraform application
│   │   └── destroy.sh                 # Cleanup script
│   │
│   └── state/                         # Terraform state management
│       └── backend.tf                 # S3 backend configuration
│
├── kubernetes/                         # Kubernetes manifests and Helm charts
│   ├── base/                          # Kustomize base configurations
│   │   ├── namespaces/                # Namespace definitions
│   │   ├── rbac/                      # RBAC roles and bindings
│   │   └── storage/                   # Storage class definitions
│   │
│   ├── overlays/                      # Environment overlays
│   │   ├── dev/                       # Development overlays
│   │   └── prod/                      # Production overlays
│   │
│   ├── applications/                  # Application deployments
│   │   ├── frontend/                  # Sample frontend application
│   │   ├── backend/                   # Sample backend API
│   │   └── database/                  # Sample database (if needed)
│   │
│   ├── observability/                 # Observability stack
│   │   ├── prometheus/                # Prometheus configuration
│   │   ├── grafana/                   # Grafana dashboards and datasources
│   │   ├── loki/                      # Loki logging stack
│   │   ├── alertmanager/              # Alerting configuration
│   │   └── kube-prometheus-stack/     # Kube Prometheus Stack Helm values
│   │
│   └── chaos-engineering/             # Fault injection tools
│       ├── chaos-mesh/                # Chaos Mesh manifests
│       └── experiments/               # Chaos experiments definitions
│
├── helm/                              # Helm charts (if not using Kustomize)
│   ├── charts/                        # Custom Helm charts
│   │   ├── sample-app/                # Sample application chart
│   │   └── observability/             # Observability chart
│   │
│   └── values/                        # Environment-specific values
│       ├── dev-values.yaml
│       └── prod-values.yaml
│
├── scripts/                           # Utility scripts
│   ├── verification/                  # Python verification tools
│   │   ├── health_check.py            # Health check verification
│   │   ├── load_test.py               # Load testing script
│   │   └── observability_validation.py # Observability validation
│   │
│   ├── monitoring/                    # Monitoring helper scripts
│   │   ├── metrics_collector.sh       # Custom metrics collection
│   │   └── log_analyzer.py            # Log analysis utilities
│   │
│   └── automation/                    # Automation scripts
│       ├── cluster_bootstrap.sh       # Cluster bootstrap
│       └── observability_setup.sh     # Observability stack setup
│
├── tests/                             # Test suites
│   ├── infrastructure/                # Terraform tests
│   │   ├── terratest/                 # Terratest integration tests
│   │   └── conftest/                  # Policy as Code tests
│   │
│   ├── kubernetes/                    # Kubernetes tests
│   │   ├── kuttl/                     # KUTTL test definitions
│   │   └── sonobuoy/                  # Cluster conformance tests
│   │
│   └── integration/                   # Integration tests
│       ├── api_tests/                 # API endpoint tests
│       └── observability_tests/       # Observability validation tests
│
├── config/                            # Configuration files
│   ├── prometheus/                    # Prometheus rules and alerts
│   │   ├── alert-rules.yml            # Alerting rules
│   │   └── recording-rules.yml        # Recording rules
│   │
│   ├── grafana/                       # Grafana configuration
│   │   ├── dashboards/                # JSON dashboard definitions
│   │   └── datasources/               # Data source configurations
│   │
│   └── fluent-bit/                    # Fluent Bit configuration
│       └── fluent-bit-config.yaml     # Log forwarding configuration
│
├── .github/                           # GitHub workflows
│   ├── workflows/                     # CI/CD pipelines
│   │   ├── terraform-validate.yml     # Terraform validation
│   │   ├── kubernetes-lint.yml        # Kubernetes manifest linting
│   │   ├── security-scan.yml          # Security scanning
│   │   └── integration-test.yml       # Integration testing
│   │
│   └── ISSUE_TEMPLATE/                # Issue templates
│       ├── bug_report.md
│       └── feature_request.md
│
└── Makefile                           # Makefile for common tasks
```

## Key Directories Explained

### 1. `infrastructure/`
Contains all Terraform code organized using modules for reusability. The environment-specific configurations allow deploying to different regions and environments.

### 2. `kubernetes/`
Follows GitOps principles with Kustomize for environment-specific overlays. Contains application deployments, observability stack configurations, and chaos engineering experiments.

### 3. `scripts/verification/`
Python-based verification tools that validate the infrastructure, Kubernetes deployments, and observability stack functionality.

### 4. `tests/`
Comprehensive test suites for infrastructure validation, Kubernetes conformance, and integration testing.

### 5. `config/`
Configuration files for observability tools like Prometheus, Grafana, and Fluent Bit.

### 6. `.github/`
CI/CD pipelines for automated validation, security scanning, and testing.

## File Naming Conventions

- **Terraform files**: Use `.tf` extension with descriptive names (`main.tf`, `variables.tf`, `outputs.tf`)
- **Kubernetes manifests**: Use `.yaml` or `.yml` extension with resource type prefix (`deployment-frontend.yaml`, `service-backend.yaml`)
- **Python scripts**: Use `.py` extension with descriptive names (`health_check.py`, `fault_injector.py`)
- **Shell scripts**: Use `.sh` extension with executable permissions
- **Configuration files**: Use appropriate extensions (`.yaml`, `.json`, `.conf`)

## Version Control Strategy

- **Main branch**: `main` - Production-ready code
- **Development branch**: `develop` - Active development
- **Feature branches**: `feature/*` - Individual features
- **Release branches**: `release/*` - Release preparation

## Documentation Strategy

- All documentation lives in the `docs/` directory
- Architecture decisions documented in `docs/architecture/decisions/`
- Root Cause Analysis templates in `docs/rca/templates/`
- API documentation auto-generated from code comments

This structure ensures separation of concerns, reusability, and maintainability while being interview-quality and easy to explain during a live demo.
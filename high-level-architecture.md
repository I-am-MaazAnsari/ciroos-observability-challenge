# High-Level Architecture

## Overview
This document outlines the simplified architecture for a production-quality AWS observability environment designed for an interview assignment. The system implements a multi-region, multi-cluster Kubernetes environment with comprehensive observability tooling, optimized for low cost and fast implementation.

## Core Architecture Components

### 1. AWS Infrastructure Layer
- **Two EKS Clusters**: Deployed across two AWS regions (e.g., us-east-1 and us-west-2)
- **VPC Design**: Each region has its own VPC with private/public subnets
- **Inter-region Connectivity**: **Inter-Region VPC Peering** (simpler and cheaper than Transit Gateway)
- **Load Balancing**: Application Load Balancer (ALB) with AWS WAF integration
- **Security**: Security groups, IAM roles, and AWS WAF rules for protection

### 2. Kubernetes Layer
- **Primary Cluster**: us-east-1 - Main application deployment
- **Secondary Cluster**: us-west-2 - Secondary cluster for demonstration purposes
- **Ingress Controller**: AWS ALB Controller for Kubernetes ingress
- **Simplified Communication**: Direct Kubernetes service discovery (no service mesh)

### 3. Observability Stack (Helm-based)
- **Metrics Collection**: Prometheus (single instance per cluster, no Thanos for simplicity)
- **Logging**: Loki with Fluent Bit for log collection
- **Visualization**: Grafana dashboards for metrics and logs
- **Alerting**: Alertmanager with basic email notifications
- **Tracing**: Optional but simplified (can be added later if needed)

### 4. Application Layer
- **Sample Microservices**: 2-3 simple Python services demonstrating basic inter-service communication
- **Fault Injection**: Simple chaos engineering with Kubernetes pod deletion/restarts
- **Verification Tool**: Python-based health check and validation tool

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                            AWS Global Infrastructure                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Region: us-east-1                    Region: us-west-2                 │
│  ┌─────────────────┐                 ┌─────────────────┐               │
│  │   VPC           │                 │   VPC           │               │
│  │  ┌────────────┐ │                 │  ┌────────────┐ │               │
│  │  │ EKS Cluster│◄─────────────────►│  │ EKS Cluster│ │               │
│  │  │ Primary    │ │ VPC Peering     │  │ Secondary  │ │               │
│  │  └────────────┘ │                 │  └────────────┘ │               │
│  │       │         │                 │       │         │               │
│  │  ┌────▼────┐    │                 │  ┌────▼────┐    │               │
│  │  │  ALB    │    │                 │  │  ALB    │    │               │
│  │  │ + WAF   │    │                 │  │ + WAF   │    │               │
│  │  └────┬────┘    │                 │  └────┬────┘    │               │
│  │       │         │                 │       │         │               │
│  └───────┼─────────┘                 └───────┼─────────┘               │
│          │                                    │                         │
│          ▼                                    ▼                         │
│  ┌─────────────────────────────────────────────────────────┐           │
│  │                 Observability Stack                     │           │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐    │           │
│  │  │Prometheus│  │  Loki   │  │ Grafana │  │Alerting│    │           │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘    │           │
│  └─────────────────────────────────────────────────────────┘           │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐│
│  │                    Python Verification & RCA Tools                  ││
│  └─────────────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────────────┘
```

## Communication Patterns

1. **North-South Traffic**: Internet → AWS WAF → ALB → Kubernetes Ingress → Services
2. **East-West Traffic**: Service-to-service within cluster via Kubernetes service discovery (no service mesh)
3. **Cross-Region Traffic**: Via Inter-Region VPC Peering (simpler than Transit Gateway)
4. **Observability Traffic**: Metrics/logs flow from each cluster to its local observability stack

## Security Considerations

- **Network Isolation**: Private subnets for EKS nodes, NAT Gateway for outbound
- **IAM Least Privilege**: Fine-grained IAM roles for EKS service accounts
- **WAF Protection**: OWASP Top 10 rules enabled on ALB
- **Encryption**: TLS termination at ALB (no mTLS between services for simplicity)
- **Secrets Management**: AWS Secrets Manager or Kubernetes secrets

## Simplification Rationale

1. **Inter-Region VPC Peering instead of Transit Gateway**:
   - Lower cost (no hourly charges for Transit Gateway)
   - Simpler configuration and maintenance
   - Sufficient for interview demonstration purposes

2. **No Service Mesh**:
   - Reduces complexity significantly
   - Eliminates learning curve for interview demonstration
   - Kubernetes native service discovery is sufficient for basic communication

3. **No mTLS between services**:
   - Simplifies certificate management
   - Reduces operational overhead
   - ALB TLS termination provides sufficient security for demo

4. **No Route53 Weighted Routing or Disaster Recovery**:
   - Focuses on core observability demonstration
   - Reduces cost and complexity
   - Interview assignment doesn't require full DR capabilities

5. **Simplified Observability**:
   - Single Prometheus instance per cluster (no Thanos)
   - Basic alerting setup
   - Focus on demonstrating core concepts rather than production-scale

## Cost Optimization Highlights

- Use Spot Instances for stateless worker nodes
- Right-size EKS node types (t3.small/t3.medium for demo)
- Use Inter-Region VPC Peering instead of Transit Gateway
- Minimal WAF rules (only essential OWASP rules)
- Single ALB per region (not multi-AZ for demo)
- Implement resource quotas and limits in Kubernetes
- Auto-scaling disabled for demo (manual scaling only)
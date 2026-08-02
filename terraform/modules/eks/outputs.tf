# outputs.tf - EKS module outputs

output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_version" {
  description = "Kubernetes version of the cluster"
  value       = aws_eks_cluster.main.version
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = local.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS nodes"
  value       = local.node_security_group_id
}

output "node_group_id" {
  description = "ID of the managed node group"
  value       = aws_eks_node_group.main.id
}

output "node_group_arn" {
  description = "ARN of the managed node group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_status" {
  description = "Status of the managed node group"
  value       = aws_eks_node_group.main.status
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN used by the EKS cluster"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_iam_role_arn" {
  description = "IAM role ARN used by the EKS node group"
  value       = aws_iam_role.eks_nodes.arn
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider (if IRSA enabled)"
  value       = var.enable_irsa ? aws_iam_openid_connect_provider.eks_oidc[0].arn : null
}

output "oidc_provider_url" {
  description = "URL of the OIDC provider (if IRSA enabled)"
  value       = var.enable_irsa ? aws_iam_openid_connect_provider.eks_oidc[0].url : null
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "vpc_id" {
  description = "VPC ID where the cluster is deployed"
  value       = var.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs used by the node group"
  value       = local.node_group_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs used by the cluster endpoint"
  value       = var.public_subnet_ids
}
# main.tf - EKS module main configuration

# Provider configuration
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = merge(
      {
        Project     = var.project
        Environment = var.environment
        ManagedBy   = "Terraform"
        Module      = "eks"
      },
      var.tags
    )
  }
}

# Local variables for naming conventions
locals {
  name_prefix     = "${var.project}-${var.environment}"
  cluster_name    = var.cluster_name != "" ? var.cluster_name : "${local.name_prefix}-eks"
  node_group_name = var.node_group_name != "" ? var.node_group_name : "${local.cluster_name}-node-group"

  # Determine security groups
  cluster_security_group_id = var.cluster_security_group_id != "" ? var.cluster_security_group_id : aws_security_group.eks_cluster[0].id
  node_security_group_id    = var.node_security_group_id != "" ? var.node_security_group_id : aws_security_group.eks_nodes[0].id

  # Subnet IDs for node group (prefer private subnets)
  node_group_subnet_ids = length(var.private_subnet_ids) > 0 ? var.private_subnet_ids : var.public_subnet_ids

  # OIDC provider URL (for IRSA)
  oidc_provider_url = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
}

# IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster" {
  name = "${local.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name = "${local.cluster_name}-cluster-role"
    },
    var.tags
  )
}

# Attach Amazon EKS Cluster Policy to cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# Optionally attach additional policies for cluster (e.g., VPC CNI, etc.)
resource "aws_iam_role_policy_attachment" "eks_cluster_vpc_cni" {
  count = var.enable_irsa ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}

# Security group for EKS cluster (if not provided)
resource "aws_security_group" "eks_cluster" {
  count = var.cluster_security_group_id == "" ? 1 : 0

  name        = "${local.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  # Allow all traffic within the security group
  ingress {
    description = "Allow all traffic within security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Allow inbound traffic from control plane (public/private endpoint)
  ingress {
    description = "Allow inbound traffic from control plane"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cluster_endpoint_public_access_cidrs
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${local.cluster_name}-cluster-sg"
    },
    var.tags
  )
}

# Security group for EKS nodes (if not provided)
resource "aws_security_group" "eks_nodes" {
  count = var.node_security_group_id == "" ? 1 : 0

  name        = "${local.cluster_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  # Allow all traffic within the security group
  ingress {
    description = "Allow all traffic within security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Allow inbound traffic from EKS cluster security group
  ingress {
    description     = "Allow traffic from EKS cluster"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [local.cluster_security_group_id]
  }

  # Allow SSH access (optional, for debugging)
  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, restrict to specific IPs
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${local.cluster_name}-nodes-sg"
    },
    var.tags
  )
}

# EKS cluster
resource "aws_eks_cluster" "main" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.public_subnet_ids
    security_group_ids      = [local.cluster_security_group_id]
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  # Enable CloudWatch logging
  enabled_cluster_log_types = var.enabled_cluster_log_types


  tags = merge(
    {
      Name = local.cluster_name
    },
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_cluster_vpc_cni
  ]
}

# IAM role for EKS node group
resource "aws_iam_role" "eks_nodes" {
  name = "${local.cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name = "${local.cluster_name}-node-group-role"
    },
    var.tags
  )
}

# Attach Amazon EKS Worker Node Policy
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

# Attach Amazon EKS CNI Policy
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

# Attach Amazon EC2 Container Registry ReadOnly Policy
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

# Optionally attach additional policies for node group (e.g., CloudWatch agent)
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_nodes.name
}

# EKS managed node group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = local.node_group_subnet_ids

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  instance_types = var.node_group_instance_types
  disk_size      = var.node_group_disk_size
  ami_type       = var.node_group_ami_type
  capacity_type  = var.node_group_capacity_type

  # Update configuration
  update_config {
    max_unavailable = 1
  }

  # Labels and taints (optional)
  labels = {
    "nodegroup" = local.node_group_name
  }

  tags = merge(
    {
      Name = local.node_group_name
    },
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly,
    aws_eks_cluster.main
  ]
}

# IAM OIDC provider for IRSA (if enabled)
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  count = var.enable_irsa ? 1 : 0

  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "9e99a48a9960b14926bb7f3b02e22da2b0ab7280" # Thumbprint for EKS OIDC (us-east-1). For other regions, adjust accordingly.
  ]

  tags = merge(
    {
      Name = "${local.cluster_name}-oidc"
    },
    var.tags
  )
}
# variables.tf - EKS module variables

variable "vpc_id" {
  description = "ID of the VPC where EKS cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS node groups"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for EKS cluster endpoint (if public access enabled)"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "ciroos-eks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "ciroos-observability"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS cluster API server endpoint is publicly accessible"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks that can access the public endpoint"
  type        = list(string)
  default = [
    "183.83.152.125/32"
  ]
}
variable "cluster_endpoint_private_access" {
  description = "Whether the EKS cluster API server endpoint is privately accessible"
  type        = bool
  default     = true
}

variable "enabled_cluster_log_types" {
  description = "List of log types to enable for CloudWatch logging"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "node_group_name" {
  description = "Name of the managed node group"
  type        = string
  default     = "managed-node-group"
}

variable "node_group_instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_group_disk_size" {
  description = "Disk size in GiB for each node"
  type        = number
  default     = 20
}

variable "node_group_ami_type" {
  description = "AMI type for the node group"
  type        = string
  default     = "AL2023_x86_64_STANDARD" # Amazon Linux 2023
}

variable "node_group_capacity_type" {
  description = "Capacity type for the node group (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "enable_irsa" {
  description = "Enable IAM Roles for Service Accounts (IRSA)"
  type        = bool
  default     = true
}

variable "cluster_security_group_id" {
  description = "Optional existing security group ID for EKS cluster. If not provided, a new one will be created."
  type        = string
  default     = ""
}

variable "node_security_group_id" {
  description = "Optional existing security group ID for EKS nodes. If not provided, a new one will be created."
  type        = string
  default     = ""
}
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Ciroos-Observability-Challenge"
      Environment = "demo"
      ManagedBy   = "Terraform"
    }
  }
}
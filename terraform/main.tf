module "network" {
  source = "./modules/network"

  region      = var.aws_region
  environment = var.environment
  project     = var.project_name

  enable_nat_gateway = true
}

module "eks" {
  source = "./modules/eks"

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids

  cluster_name = "${var.project_name}-eks"

  region      = var.aws_region
  environment = var.environment
  project     = var.project_name

  tags = {
    Project = var.project_name
  }
}
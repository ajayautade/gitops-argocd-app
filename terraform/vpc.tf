# ==============================================================================
# VPC Module (Virtual Private Cloud)
# Creates a reliable network foundation with Public and Private subnets suitable 
# for an EKS cluster. 
# ==============================================================================

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  # EKS requires the VPC to span at least two Availability Zones
  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # Enable NAT Gateway so private subnets can reach the internet (download patches/images)
  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true

  # Specific tags required by Kubernetes to discover subnets for LoadBalancers
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

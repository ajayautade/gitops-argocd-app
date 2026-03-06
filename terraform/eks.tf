# ==============================================================================
# EKS Cluster Module
# Provisions the fully managed Kubernetes control plane and Worker Nodes.
# ==============================================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  # Connect the cluster to our newly created VPC and Subnets
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Allow public access to the K8s API (so we can run kubectl from our laptop)
  cluster_endpoint_public_access = true

  # Managed Node Groups (The actual EC2 servers that will run our Docker containers)
  eks_managed_node_groups = {
    standard_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
      
      instance_types = ["t3.medium"] # t3.medium is the minimum recommended size for EKS
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "production"
    Application = "gitops-argocd"
  }
}

# ==============================================================================
# EKS Cluster Module
# Provisions the fully managed Kubernetes control plane and Worker Nodes.
# ==============================================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30" # EKS only allows upgrading one minor version at a time

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

      instance_types = ["t3.small"] # 2 GB RAM minimum needed for K8s + ArgoCD + Monitoring
      capacity_type  = "ON_DEMAND"

      # Use AL2023 - AWS retired the old Amazon Linux 2 (AL2) EKS AMIs in November 2025
      ami_type = "AL2023_x86_64_STANDARD"
    }
  }

  tags = {
    Environment = "production"
    Application = "gitops-argocd"
  }
}

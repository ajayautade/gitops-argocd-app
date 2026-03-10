# ==============================================================================
# Continuous Deployment: ArgoCD Helm Installation
# 
# What makes this unique: We use Terraform's Helm provider to automatically 
# bootstrap ArgoCD onto the cluster the moment the cluster finishes building!
# This gives you a true "Zero to GitOps" pipeline with one command.
# ==============================================================================

# Create a dedicated namespace for ArgoCD keeping things organized
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  # Ensure the namespace is only created AFTER the EKS cluster is fully ready
  depends_on = [module.eks]
}

# Use the official Helm chart to deploy ArgoCD
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.7"  # Use a stable version
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  wait       = false     # Don't block Terraform waiting for all pods
  timeout    = 600       # 10 minute timeout

  # Expose the ArgoCD UI natively using a LoadBalancer instead of port-forwarding
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  depends_on = [kubernetes_namespace.argocd]
}

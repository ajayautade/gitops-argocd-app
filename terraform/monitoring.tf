# ==============================================================================
# Observability: Prometheus and Grafana Helm Installation
# 
# Automatically installs the kube-prometheus-stack which provides complete
# monitoring for the Kubernetes cluster and our applications.
# ==============================================================================

# Create a dedicated namespace for monitoring tools
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [module.eks]
}

# Install Prometheus & Grafana stack using the official Helm chart
resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "56.6.2" # Stable version

  # Expose Grafana via a LoadBalancer so we can access the dashboards easily
  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  # Set a simple default admin password for Grafana (Change this in production!)
  set {
    name  = "grafana.adminPassword"
    value = "admin"
  }

  depends_on = [kubernetes_namespace.monitoring]
}

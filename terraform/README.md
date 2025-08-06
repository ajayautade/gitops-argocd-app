# ☁️ Infrastructure as Code (Terraform)

This folder contains the automation code to completely build our AWS environment from scratch. 

It does three major things in a single run:
1. **Network:** Builds a highly available VPC with public and private subnets.
2. **Compute:** Provisions an Amazon EKS (Elastic Kubernetes Service) cluster with managed EC2 worker nodes.
3. **Bootstrap:** Uses the Terraform Helm provider to automatically install **ArgoCD** onto the cluster the second it finishes building.

## 🚀 How to deploy the infrastructure

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Preview the changes
```bash
terraform plan
```

### 3. Build the Cluster (~15 Minutes)
```bash
terraform apply
```

### 4. Connect to your new cluster!
After applying, Terraform will output a command to update your local Kubernetes config file. It looks like this:
```bash
aws eks --region ap-south-1 update-kubeconfig --name gitops-argocd-cluster
```

## 🔐 How to log in to ArgoCD

Terraform automatically deployed ArgoCD and exposed it as a LoadBalancer.

1. Get the ArgoCD URL:
```bash
kubectl get svc argocd-server -n argocd
# Copy the EXTERNAL-IP address and open it in your browser (ignore the SSL warning)
```

2. Get your default admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

Username is: `admin`

## 💣 How to Clean Up (Save Money!)
When you are done testing, you must destroy the cluster so AWS doesn't charge you! EKS costs ~$73/month.
```bash
terraform destroy
```

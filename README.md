# 🚀 End-to-End GitOps Pipeline & Kubernetes Infrastructure

A complete, production-ready DevOps portfolio project demonstrating automated cloud infrastructure provisioning, Continuous Deployment via GitOps, and fully integrated cluster monitoring.

## 🌟 What This Project Does

This project is not just a simple web app. It is a fully automated, professional DevOps environment built from scratch:

1. **Infrastructure as Code:** Uses **Terraform** to automatically build a highly available AWS Virtual Private Cloud (VPC) and an Amazon EKS (Kubernetes) cluster.
2. **Bootstrapping Layer:** Terraform automatically leverages Helm to install **ArgoCD** (for GitOps) and the **Prometheus + Grafana** stack (for monitoring) the moment the cluster is ready.
3. **Application Containerization:** A Python Flask API packaged in a highly optimized, secure Alpine Docker image.
4. **Continuous Integration (CI):** A **GitHub Actions** pipeline that automatically builds a new Docker image and pushes it to DockerHub every time new code is merged.
5. **GitOps CD Pipeline:** ArgoCD continuously monitors this Git repository. When GitHub Actions updates the Kubernetes manifests with the new image tag, ArgoCD instantly detects the changes and automatically syncs the live EKS cluster, guaranteeing zero configuration drift.

---

## 🏗️ How to Deploy the Entire Project

### Step 1: Provision Cloud Infrastructure (Terraform)
Instead of clicking around the AWS console manually, use Terraform to build the cluster and install the DevOps tools.
```bash
cd terraform/
terraform init

# ⏳ Takes ~15 minutes to build the VPC, EKS Cluster, ArgoCD, and Grafana!
terraform apply
```

### Step 2: Connect to your Cluster
Terraform will output a command to configure your local terminal. It looks like this:
```bash
aws eks --region ap-south-1 update-kubeconfig --name gitops-argocd-cluster
```

### Step 3: Configure CI/CD Secrets
To allow GitHub Actions to build and push your Docker image automatically:
1. Go to your GitHub Repository Settings -> Secrets and variables -> Actions
2. Add `DOCKERHUB_USERNAME` (Your Docker Hub username)
3. Add `DOCKERHUB_TOKEN` (An access token generated from Docker Hub)

### Step 4: Access your DevOps Tools
You can now log into the tools Terraform automatically installed for you:

**ArgoCD:**
```bash
kubectl get svc argocd-server -n argocd
# Visit the EXTERNAL-IP in your browser. Target username is 'admin'.
# Run this to get your password:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

**Grafana:**
```bash
kubectl get svc kube-prometheus-stack-grafana -n monitoring
# Visit the EXTERNAL-IP in your browser. 
# Username: admin | Password: admin
```

### Step 5: Deploy the App via GitOps
Now that your AWS infrastructure is running, tell ArgoCD to deploy this repository!

1. Update `argocd-app.yaml` with your own GitHub repository URL (if you forked this).
2. Apply the application manifest:
```bash
kubectl apply -f argocd-app.yaml
```

**Boom! 🚀** 
ArgoCD will read the `k8s/` folder in this repo and automatically deploy the Python API to your EKS cluster. If you edit the `app.py` Python code and run `git push`, the GitHub Actions CI pipeline will automatically build the new image, update the K8s manifest, and ArgoCD will automatically roll out the changes without you ever touching the cluster!

---

## 💣 Clean Up (Avoid AWS Charges!)
EKS control planes cost money. When you are done learning/testing, destroy EVERYTHING with one command:
```bash
cd terraform/
terraform destroy
```

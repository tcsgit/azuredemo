## Helm - Terraform Deployment and ArgoCD GitOps Pipeline @Azure-AKS

## Requirements

1. Azure Account & CLI

2. Terraform 1.1.x

2. Helm - 3.x.x

3. ArgoCD - 2.2.2

## Steps to Deployment

**1. Clone the repository**

```bash
git clone https://github.com/tcsgit/azuredemo.git
cd azuredemo
```

**2. Create Azure kubernetes cluster, container registry and role assignment with Terraform**

```bash
cd terraform
terraform apply
```

**3. Configure kubectl to connect to your kubernetes cluster **

```bash
az aks get-credentials --admin --name tcsgcluster --resource-group tcsgresources
```

**4. Build container image and push registry**

```bash
cd demo
az acr build --image asademo:1.0 --registry tcsgregistry --file Dockerfile .
```

**5. Deploy the application on kubernetes cluster using kubectl or helm**

```bash
cd demo
kubectl apply -f asademo-deployment.yaml
|
cd helm
helm upgrade --install asademo demo-chart/ --namespace asademo --create-namespace
```

## Steps to ArgoCD Setup

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=”{.data.password}” | base64 -d && echo

argocd login <ARGOCD_SERVER>
argocd app create azuredemo –repo https://github.com/tcsgit/azuredemo.git –path helm/demo-chart –dest-server https://kubernetes.default.svc –dest-namespace default

```

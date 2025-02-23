#!/bin/bash
# Install Ansible
sudo apt update && sudo apt install -y ansible

# Run Ansible playbook
ansible-playbook -i ansible/inventory ansible/playbook.yaml

# Configure MetalLB after cluster setup
kubectl wait --for=condition=Ready nodes --all --timeout=300s
kubectl apply -k kustomize/overlays/production/

# Get Argo CD password
argo_password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Argo CD Admin Password: $argo_password"

# Port-forward Argo CD
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
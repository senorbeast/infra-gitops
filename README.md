# Home Server GitOps Platform

Production-grade Kubernetes home server with full GitOps workflow.

## Features

- 🔒 Secure SSH access with automatic key rotation
- ☸️ Lightweight k3s Kubernetes cluster
- 🔄 Argo CD GitOps with auto-sync
- 📊 Monitoring stack (Prometheus/Grafana)
- 💾 Persistent storage with local-path provisioner
- 🤖 Automated backups and disaster recovery

## Prerequisites

- Ubuntu 22.04 LTS Server
- 4GB+ RAM (8GB recommended)
- SSD for Kubernetes workloads
- Static IP address
- Ensure **Ansible is installed** on your local machine:
  ```sh
  sudo apt install ansible  # For Debian/Ubuntu
  brew install ansible      # For macOS
  ```
- SSH access to the remote server.
- A valid **inventory file** (`inventory`) with your server details.

---

## Quick Start

## **1️⃣ Install & Configure K3s on Remote Server**

Run the following command to set up K3s, after SSHing:

```sh
ansible-playbook -i ansible/inventory ansible/home-server.yaml
```

This will:  
✔ Install required packages  
✔ Set up firewall rules  
✔ Install K3s with custom options  
✔ Configure ZRAM swap

---

```bash

# Deploy base infrastructure
kustomize build k3s/base | kubectl apply -f -
kustomize build k3s/overlays/production | kubectl apply -f -

# Install Argo CD
kustomize build argo/base | kubectl apply -f -
kubectl wait -n argocd --for=condition=Ready pods --all --timeout=300s

# Access Argo CD UI
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## **2️⃣ Retrieve K3s Kubeconfig for Local Access**

Run this command to copy the kubeconfig file and set up an SSH tunnel:

```sh
ansible-playbook -i ansible/inventory ansible/k9s-kubeconfig.yaml
```

This will:  
✔ Fetch the kubeconfig from the remote server  
✔ Modify it to work with an SSH tunnel  
✔ Start an SSH tunnel for Kubernetes API access

```sh
# Now just run k9s on local machine (to see your server k3s setup)
k9s
```

````

## Architecture

```mermaid
graph TD
    A[GitHub Repo] -->|Push| B[Argo CD]
    B -->|Sync| C[k3s Cluster]
    C --> D[Persistent Storage]
    C --> E[Monitoring]
    C --> F[React App]
    G[Local Network] -->|LB IP| F
```

## Maintenance

**Backup etcd**:

```bash
./scripts/backup-etcd.sh
```

**Upgrade k3s**:

```bash
ansible-playbook -i ansible/inventory ansible/playbook.yaml --tags k3s-upgrade
```

**Monitor Resources**:

```bash
kubectl top pods --all-namespaces
```

## Security Best Practices

1. Enable Argo CD SSO integration
2. Rotate admin password after initial setup
3. Use network policies to isolate workloads
4. Enable automatic security updates
5. Regular vulnerability scans with Trivy

## Troubleshooting

**Argo CD Sync Issues**:

```bash
argocd app get <app-name> --hard-refresh
```

**Node Resource Exhaustion**:

```bash
kubectl describe node | grep -A 3 Allocated
```

**Persistent Volume Recovery**:

```bash
sudo ls -lh /var/lib/rancher/k3s/storage
```

## License

MIT License - See [LICENSE](LICENSE) for details.

```

**Key Components Explained**:

1. **Ansible Automation**:
   - Handles OS hardening and k3s installation
   - Configures zram for memory optimization
   - Sets up automated etcd snapshots

2. **Kustomize Layers**:
   - Base configuration for cluster essentials
   - Production overlay with MetalLB load balancer
   - Environment-specific patches

3. **Argo CD GitOps**:
   - App-of-Apps pattern for managing deployments
   - Automatic synchronization every 3 minutes
   - Self-healing capabilities

4. **Monitoring Stack**:
   - Prometheus with 15-day retention
   - Grafana with preconfigured dashboards
   - Alertmanager for critical notifications

**Post-Installation Steps**:

1. Configure DNS records for your services
2. Set up OAuth2 proxy for Argo CD access
3. Enable encrypted backups to cloud storage
4. Configure network policies for pod isolation

This implementation provides a production-ready home server with full GitOps capabilities while maintaining minimal resource usage. All components can be managed through the Git repository with full audit history.

````

Here’s a simple **README.md** for your Ansible setup:

---

### **Ansible K3s Setup and Kubeconfig Fetcher**

This project contains Ansible playbooks to:

1. **Install & configure K3s** on a remote server.
2. **Retrieve the K3s kubeconfig** to set up local access.

---

## **Inventory File Example (`inventory`)**

Ensure your `inventory` file is correctly set up:

```ini
[server]
my_server ansible_host=192.168.0.113 ansible_user=beasty

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

Replace `192.168.0.113` and `beasty` with your actual server IP and user.

---

## **Usage Notes**

- Run both playbooks in order (`playbook.yaml` first, then `kubeconfig.yaml`).
- The SSH tunnel will allow `kubectl` to communicate with your K3s cluster via `127.0.0.1:6443`.
- To confirm everything is working, run:
  ```sh
  kubectl get nodes
  ```

🚀 **You're all set!** 🚀

# 🚀 My Home Server SSH & Kubernetes Access

This setup automates SSH access and port forwarding for a **Kubernetes home server** running **Argo CD** and **k3s**.

## **🔧 Configuration**

Ensure your **~/.ssh/config** file includes:

```ini
Host metalserver
    HostName 192.168.0.55
    User beasty
    ForwardAgent yes
    LocalForward 6443 localhost:6443
    LocalForward 8080 localhost:8080
```

This allows you to connect to `metalserver` with automatic **port forwarding**.

## **📌 Steps to Connect**

1️⃣ **Start SSH session with port-forwarding** (background process):

```sh
ssh metalserver 'kubectl port-forward svc/argocd-server -n argocd 8080:443' &
```

2️⃣ **Verify Kubernetes Access Locally:**

```sh
kubectl get nodes
```

3️⃣ **Access Argo CD UI** at:  
➡️ [https://localhost:8080](https://localhost:8080)

---

## **🎯 tmux Workspace Setup**

To launch **tmux** with:

- **k9s taking most of the screen**
- **One SSH terminal (bottom left)**
- **One local terminal (bottom right)**

Run this **single command**:

WIP

```sh
tmux has-session -t home-server 2>/dev/null && tmux attach-session -t home-server || \
tmux new-session -d -s home-server \; \
  send-keys 'k9s' C-m \; \
  split-window -v -p 40 \; \
  split-window -h -p 50 \; \
  select-pane -t 1 \; send-keys 'ssh -t metalserver' C-m \; \
  send-keys 'sleep 5 && kubectl port-forward svc/argocd-server -n argocd 8080:443 >/dev/null 2>&1 &' C-m \; \
  select-pane -t 2 \; send-keys 'echo Local Terminal' C-m \; \
  select-pane -t '{last}' \; \
  attach-session

```

FIX: run inside one of tmux's pane

```sh
  ssh -t metalserver && kubectl port-forward svc/argocd-server -n argocd 8080:443
```

```sh
tmux kill-session -t home-server
```

### **💡 What This Does:**

✅ **Pane 0** (Top): Runs `k9s` for managing the cluster (60% screen).  
✅ **Pane 1** (Bottom Left): SSH into `metalserver`.  
✅ **Pane 2** (Bottom Right): Local terminal for additional commands.

Now, just **run the tmux command** and enjoy a fully set up workspace! 🚀

---

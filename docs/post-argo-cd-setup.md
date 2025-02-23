# ArgoCD Setup and SSH Agent Forwarding Guide

## Post ArgoCD Installation Steps

After installing ArgoCD, follow these steps to retrieve the admin credentials and access the UI.

### 1. Retrieve the Initial Admin Password

Run the following command to get the default admin password for ArgoCD:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
 -o jsonpath="{.data.password}" | base64 -d && echo
```

### 2. Access the ArgoCD UI Locally

Forward local port `8080` to the ArgoCD server's port `443`:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

#### Expected Output:

```
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
```

### 3. Access ArgoCD UI from a Remote Machine

If accessing ArgoCD from a remote machine, create an SSH tunnel:

```bash
ssh -L 8080:localhost:8080 beasty@192.168.0.55
```

- This forwards port `8080` on your **local machine** to port `8080` on the **remote server** (`192.168.0.55`).
- Once connected, open a browser and go to:
  ```
  http://localhost:8080
  ```

#### Login Credentials:

- **Username:** `admin`
- **Password:** Retrieved in Step 1

---

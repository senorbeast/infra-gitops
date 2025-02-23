## SSH Agent Forwarding

SSH Agent Forwarding allows the remote server to use your **local SSH keys** for authentication without storing them on the server.

### 1. Connect to the Server with SSH Agent Forwarding

```bash
ssh -A beasty@<server-ip>
```

### 2. Verify That Your SSH Key Is Available on the Server

```bash
ssh-add -L
```

#### Expected Output:

- If successful, it will display your public SSH key.
- If you see `"The agent has no identities"`, it means your SSH key isn't loaded.

### 3. If No Keys Are Found, Load Your SSH Key on the Local Machine

Run the following command on your **local machine**:

```bash
ssh-add ~/.ssh/id_rsa
```

Then, reconnect to the server:

```bash
ssh -A beasty@<server-ip>
```

### 4. Test the SSH Connection to GitHub from the Server

```bash
ssh -T git@github.com
```

#### Expected Output:

```
Hi <your-github-username>! You've successfully authenticated, but GitHub does not provide shell access.
```

### 5. Clone a Private GitHub Repository

```bash
git clone git@github.com:senorbeast/gitops.git
```

---

## Why Use SSH Agent Forwarding?

- **Security:** Your private SSH key **remains on your local machine** and is **not copied** to the server.
- **Convenience:** The remote server can authenticate with services (e.g., GitHub) using your **local SSH key**.
- **Best Practice:** Avoids storing SSH keys on remote servers, reducing security risks.

---

### ✅ You're All Set!

Now you can securely access private repositories using SSH Agent Forwarding. 🚀

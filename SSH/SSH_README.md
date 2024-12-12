# SSH Configuration for Automatic Key Usage

This guide explains how to set up SSH to use a specific private key automatically when connecting to a remote server.

---

## Steps

### 1. Generate a New SSH Key Pair
1. Open a terminal and run:
   ```bash
   ssh-keygen -t ed25519 -C "random_name_for_identitfication"
   ```


2. Save the key to the default location (`~/.ssh/id_ed25519`) or provide a custom name like `~/.ssh/k3s-master`.

3. View and copy the public key:
   ```bash
   cat ~/.ssh/k3s-master.pub
   ```

---

### 2. Access the Remote Server and add the Public Key to the Remote Server
1. Log in to the remote server (using an alternate method if necessary).
2. Create the SSH directory (if it doesn’t already exist):
   ```bash
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   ```
3. Add the public key to the `authorized_keys` file:
   ```bash
   nano ~/.ssh/authorized_keys
   ```
   Paste the copied key into the file and save it.

4. Set the correct permissions:
   ```bash
   chmod 600 ~/.ssh/authorized_keys
   ```

---

### 3. Configure SSH to Use the Key Automatically
1. On your local machine, open or create the SSH configuration file:
   ```bash
   nano ~/.ssh/config
   ```

2. Add the following configuration:
   ```plaintext
   Host k3s-master
       HostName 192.168.1.31
       User root
       IdentityFile ~/.ssh/k3s-master
   ```

   Replace:
   - `k3s-master` with an alias for your host.
   - `192.168.1.31` with your server's IP or hostname.
   - `~/.ssh/k3s-master` with the path to your private key.

3. Save the file and ensure it has the correct permissions:
   ```bash
   chmod 600 ~/.ssh/config
   ```
---
### 4. Ensure the SSH Server Allows Public Key Authentication
Make sure that the SSH server on 192.168.1.31 is configured to accept public key authentication. To check, log into the VM using another method (e.g., password) and open the ```/etc/ssh/sshd_config file:```

```bash
sudo nano /etc/ssh/sshd_config
```
Ensure that the following lines are present and not commented out:
```bash
PubkeyAuthentication yes
AuthorizedKeysFile     .ssh/authorized_keys
```
After making any changes, restart the SSH service:

```bash
sudo systemctl restart sshd
```

---

### 5. Test the Configuration
- Connect using the alias:
  ```bash
  ssh k3s-master
  ```
- If you want to connect directly using the IP, modify the `Host` section:
  ```plaintext
  Host 192.168.1.31
      User root
      IdentityFile ~/.ssh/k3s-master
  ```

---

## Additional Notes
- Ensure the SSH service is running and configured properly on the remote server:
  ```bash
  sudo systemctl restart ssh
  ```
- If issues persist, debug with:
  ```bash
  ssh -v k3s-master
  ```
```

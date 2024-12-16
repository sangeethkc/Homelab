# Proxmox VM Automation Script #

This script automates the creation of virtual machines (VMs) on a Proxmox server. It is designed to set up a High Availability (HA) K3s cluster with 3 master nodes and 2 agent nodes. Each VM is assigned a hostname, and root user credentials (`root/root123`).


## **Features**
- Automatically clones VMs from a template.
- Sets up a `root` user with a predefined password (`root123`).
- Assigns unique hostnames to master and agent nodes.
- Configures VM resources (CPU, memory, and network).
- Supports customization for additional nodes or different configurations.

---

## **Requirements**
1. **Proxmox VE Environment**:
   - A Proxmox VE server with `qm` commands available.
2. **Template VM**:
   - The template VM must have:
     - `cloud-init` installed and properly configured.
3. **Proxmox Network**:
   - A bridge (e.g., `vmbr0`) must be configured on Proxmox for networking.
4. **Shell Access**:
   - The script should be run as `root` or with sufficient privileges to execute `qm` commands.

---


## Script Configuration

The script creates the following nodes:

- **Masters**: `k3s-master1`, `k3s-master2`, `k3s-master3`
- **Agents**: `k3s-agent1`, `k3s-agent2`

Each VM is assigned:

- **Memory**: 1GB
- **Cores**: 1
- **Root password**: `root123`

Modify the variables in the script if needed:
- `TEMPLATE_ID`: ID of the VM template.
- `STORAGE`: Storage location in Proxmox.
- `VM_START_ID`: Starting ID for the VMs.
- `ROOT_PASSWORD`: Password for the root user.

2. **Run the Script**:
   Save the script as `create_k3s_vms.sh`, make it executable, and run it:
   ```bash
   chmod +x create_k3s_vms.sh
   ./create_k3s_vms.sh
   ```
3. Wait for the script to complete. It will create the VMs with the specified configurations.

## Post-Creation Steps

1. **Start the Nodes**:
   Use the Proxmox interface or the CLI to start all the created nodes:
   ```bash
   qm start <VM_ID>
   ```

2. **Wait for Cloud-Init to Complete**:
   Wait for cloud-init to finish configuring the nodes.

3. **Retrieve IP Addresses**:
   Log in to each node via the Proxmox console or SSH, then use `ip a` to fetch its IP address.

4. **Copy SSH Keys**:
   Copy the `id_rsa` and `id_rsa.pub` files from the Proxmox server to your personal system to access the nodes:
   ```bash
   scp root@<Proxmox_IP>:/root/.ssh/id_rsa ~/.ssh/id_rsa
   scp root@<Proxmox_IP>:/root/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub
   ```

## Notes

- Make sure DHCP is enabled on your network to assign IP addresses to the nodes.
- Verify cloud-init and `qemu-guest-agent` are properly configured in the VM template.

---

## **Customizations**
You can easily modify the script to:
- Add more master or agent nodes by adding names to the NODES array
- Change resource allocation by adjusting `--cores` and `--memory`.
- Use a different username or password for the VMs.

---

## **Example Output**
After running the script, the following VMs will be created:
| VM ID | Hostname       |
|-------|----------------|
| 401   | k8s-master1    |
| 402   | k8s-master2    |
| 403   | k8s-master3    |
| 404   | k8s-agent1     |
| 405   | k8s-agent2     |

---

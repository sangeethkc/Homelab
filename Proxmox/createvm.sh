#!/bin/bash

# Configuration
TEMPLATE_ID=8000
STORAGE="lvm-local"
NODES=("k3s-master1" "k3s-master2" "k3s-master3" "k3s-agent1" "k3s-agent2")
VM_START_ID=401  # Starting VM ID
ROOT_PASSWORD="root123"

# SSH key (path to your public key)
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

# Create and configure VMs sequentially
for i in "${!NODES[@]}"; do
    VM_ID=$((VM_START_ID + i))
    VM_NAME=${NODES[i]}

    echo "Creating VM: $VM_NAME (ID: $VM_ID)"
    qm clone $TEMPLATE_ID $VM_ID --name $VM_NAME --full
    qm set $VM_ID --memory 1024 --cores 1
    qm set $VM_ID --sshkey "$SSH_KEY" --ciuser root --cipassword $ROOT_PASSWORD

    echo "$VM_NAME created".
done

echo "All VMs created."

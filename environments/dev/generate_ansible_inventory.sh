#!/bin/bash
# Navigate to the script's directory (which is infrastructure/environments/dev/)
cd "$(dirname "$0")"

echo "Generating Ansible Inventory..."

# Get outputs from Terraform
BASTION_PUBLIC_IP=$(terraform output -raw bastion_public_ip)
K3S_SERVER_PRIVATE_IP=$(terraform output -raw k3s_server_private_ip)
K3S_AGENT_PRIVATE_IP=$(terraform output -raw k3s_agent_private_ip)
SSH_KEY_PATH="task2-bastion-key.pem" # Path relative to this script

# Create inventory.ini
cat << EOF > inventory.ini
[all:vars]
ansible_user=ubuntu
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=./$SSH_KEY_PATH

[bastion]
bastion ansible_host=$BASTION_PUBLIC_IP

[k3s_server]
k3s_server_node ansible_host=$K3S_SERVER_PRIVATE_IP ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q -i $SSH_KEY_PATH ubuntu@$BASTION_PUBLIC_IP"'

[k3s_agent]
k3s_agent_node ansible_host=$K3S_AGENT_PRIVATE_IP ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q -i $SSH_KEY_PATH ubuntu@$BASTION_PUBLIC_IP"'

[k3s_nodes:children]
k3s_server
k3s_agent
EOF

echo "Ansible Inventory generated at inventory.ini"
echo "Bastion Public IP: $BASTION_PUBLIC_IP"
echo "K3s Server Private IP: $K3S_SERVER_PRIVATE_IP"
echo "K3s Agent Private IP: $K3S_AGENT_PRIVATE_IP"
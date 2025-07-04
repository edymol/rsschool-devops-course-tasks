#!/bin/bash
BASTION_IP=$(terraform output -raw bastion_public_ip)
SERVER_IP=$(terraform output -raw k3s_server_private_ip)
AGENT_IP=$(terraform output -raw k3s_agent_private_ip)

cat << EOF > ansible_inventory.ini
[k3s_server_node]
${SERVER_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/tmp/bastion_key.pem ansible_ssh_common_args='-o ProxyCommand="ssh -i /tmp/bastion_key.pem -W %h:%p ubuntu@${BASTION_IP}"'

[k3s_agent_node]
${AGENT_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/tmp/bastion_key.pem ansible_ssh_common_args='-o ProxyCommand="ssh -i /tmp/bastion_key.pem -W %h:%p ubuntu@${BASTION_IP}"'

[k3s_nodes:children]
k3s_server_node
k3s_agent_node
EOF
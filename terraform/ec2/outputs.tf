output "k3s_server_private_ip" {
  value       = aws_instance.k3s_server[0].private_ip
  description = "Private IP address of the K3s server node for Ansible."
}

output "k3s_agent_private_ip" {
  value       = aws_instance.k3s_agent[0].private_ip
  description = "Private IP address of the K3s agent node for Ansible."
}
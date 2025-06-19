output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "private_security_group_id" {
  value = aws_security_group.private_sg.id
}

output "bastion_key_name" {
  value = aws_key_pair.bastion_key.key_name
}

output "bastion_private_key" {
  value     = tls_private_key.bastion_key.private_key_pem
  sensitive = true
}

output "bastion_public_ip" {
  value       = aws_instance.bastion[0].public_ip
  description = "Public IP of the bastion host"
}

output "bastion_key_pem_path" {
  value = local_file.private_key_pem.filename
}

output "bastion_key_pub_path" {
  value = local_file.public_key_pub.filename
}
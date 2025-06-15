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
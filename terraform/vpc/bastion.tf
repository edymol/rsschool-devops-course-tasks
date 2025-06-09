resource "aws_instance" "bastion" {
  # This makes the bastion optional. It will only be created if a key_name is provided.
  count = var.key_name != "" ? 1 : 0

  ami           = var.bastion_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public[0].id

  # This is critical to make the bastion reachable from the internet.
  associate_public_ip_address = true

  # The more common argument for security groups in the same VPC.
  security_groups = [aws_security_group.bastion_sg.id]

  # Use the variable to avoid hardcoding.
  key_name      = var.key_name

  tags = {
    Name = "${var.project_name}-bastion-host"
  }
}
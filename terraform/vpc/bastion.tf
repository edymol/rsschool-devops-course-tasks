terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = var.key_name
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.bastion_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

resource "local_file" "public_key_pub" {
  content         = tls_private_key.bastion_key.public_key_openssh
  filename        = "${path.module}/${var.key_name}.pub"
  file_permission = "0644"
}

resource "aws_instance" "bastion" {
  count                       = 1
  ami                         = var.bastion_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.bastion_key.key_name
  tags = {
    Name = "${var.project_name}-bastion-host"
  }
}
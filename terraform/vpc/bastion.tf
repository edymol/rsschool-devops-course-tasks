# This tells Terraform we need the "tls" provider to generate keys
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

# This resource generates a new 4096-bit RSA key pair in memory
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# This resource takes the PUBLIC key from the pair we just generated
# and uploads it to your AWS account with a specific name.
resource "aws_key_pair" "bastion_key" {
  key_name   = "${var.project_name}-bastion-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

# This resource takes the PRIVATE key from the pair we just generated
# and saves it to a file on your local computer. Note: This works locally but not in CI.
resource "local_file" "private_key_pem" {
  content         = tls_private_key.bastion_key.private_key_pem
  filename        = "${aws_key_pair.bastion_key.key_name}.pem"
  file_permission = "0400"
}

# Bastion Host
resource "aws_instance" "bastion" {
  count                       = 1 # Always create the bastion with the generated key
  ami                         = var.bastion_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "${var.project_name}-bastion-host"
  }
}
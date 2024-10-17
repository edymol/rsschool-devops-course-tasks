# Security group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.k8s_vpc.id  # Ensure this VPC ID matches your existing VPC

  dynamic "ingress" {
    for_each = var.local_ip
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [format("%s/32", ingress.value)]  # Corrected to use format function
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "Bastion Security Group"
  }
}

# Security group for Private VMs
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.k8s_vpc.id  # Ensure this VPC ID matches your existing VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allow SSH access from the private network (adjust as needed)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "Private Security Group"
  }
}


# Security Group for the EC2 instance
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.k8s_vpc.id

  dynamic "ingress" {
    for_each = var.local_ip
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [format("%s/32", ingress.value)]  # Corrected to use format function
    }
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance Resource
resource "aws_instance" "private_vm" {
  ami           = "ami-03d1b2fa19c17c9f1"  # Replace with your desired AMI ID
  instance_type = "t2.micro"               # Instance type, free tier eligible

  subnet_id              = aws_subnet.private_subnet_1.id  # Reference to your private subnet
  vpc_security_group_ids = [aws_security_group.private_sg.id]  # Reference the security group

  key_name = "rs-school"  # Replace with the SSH key pair name

  tags = {
    Name = "PrivateVM"  # Tags for easy identification
  }
}


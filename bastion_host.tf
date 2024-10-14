# Security group for the Bastion Host (public) - this part you already have
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.k8s_vpc.id

  dynamic "ingress" {
    for_each = var.local_ip
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [format("%s/32", ingress.value)]  # Correct use of format function
    }
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Add this block for the Bastion Host EC2 instance
resource "aws_instance" "bastion_host-rs" {
  ami           = "ami-03d1b2fa19c17c9f1"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id  # Reference to a public subnet
  key_name      = "rs-school-eu"  # Use the same key pair you created

  # Attach the security group defined above
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  # Tag to identify the instance as the Bastion Host
  tags = {
    Name = "BastionHostRS"
  }
}



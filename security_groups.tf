resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]  # Your IP range for SSH access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BastionHostSG"
  }
}
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.k8s_vpc.id

  ingress {
    protocol   = "-1"  # All traffic
    from_port  = 0
    to_port    = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol   = "-1"  # All traffic
    from_port  = 0
    to_port    = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PrivateSecurityGroup"
  }
}

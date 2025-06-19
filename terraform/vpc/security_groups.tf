
resource "aws_security_group" "bastion_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH from trusted IP to bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = [var.my_ip]
    description = "SSH access to bastion from trusted IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}


# -----------------------------------------------------------------------------
# PRIVATE SECURITY GROUP
#
# Controls access for all resources in private subnets (e.g., K3s nodes).
# - Allows SSH/k3s access ONLY from the bastion.
# - Allows all traffic between instances within this same group.
# -----------------------------------------------------------------------------
resource "aws_security_group" "private_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project_name}-private-sg"
  description = "For private resources like K3s nodes"

  # Rule 1: Allow SSH from the bastion host
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "Allow SSH from bastion"
  }

  # Rule 2: Allow k3s API access from the bastion host
  ingress {
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "Allow k3s API server access from bastion"
  }

  # Rule 3: Allow all traffic between any instances within this group
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all traffic within the private security group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic (e.g., to NAT Gateway)"
  }

  tags = {
    Name = "${var.project_name}-private-sg"
  }
}


# -----------------------------------------------------------------------------
# PUBLIC SECURITY GROUP
#
# Controls access for resources in public subnets (e.g., load balancers, web servers).
# - Allows public web traffic (HTTP/HTTPS).
# - Allows SSH access ONLY from the bastion host for management.
# -----------------------------------------------------------------------------
resource "aws_security_group" "public_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project_name}-public-sg"
  description = "For public-facing resources like web servers"

  # Rule 1 (Management): Allow SSH ONLY from the bastion host
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "Allow SSH access ONLY from the bastion host"
  }

  # Rule 2 (Public Access): Allow HTTP traffic from the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from the internet"
  }

  # Rule 3 (Public Access): Allow HTTPS traffic from the internet
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from the internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project_name}-public-sg"
  }
}
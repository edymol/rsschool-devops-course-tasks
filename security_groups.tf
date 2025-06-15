# security_group.tf

resource "aws_security_group" "public_sg" {
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


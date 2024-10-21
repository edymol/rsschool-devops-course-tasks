# resource "aws_security_group" "bastion_sg" {
#   vpc_id = aws_vpc.k8s_vpc.id
#
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.my_ip_cidr]  # Your IP range for SSH access
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = "BastionHostSG"
#   }
# }

resource "aws_instance" "bastion_host_rs" {
  ami           = "ami-008d05461f83df5b1"  # Amazon Linux 2 Free Tier Eligible
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "BastionHostRS"
  }
}

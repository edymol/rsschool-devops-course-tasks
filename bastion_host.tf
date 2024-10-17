resource "aws_instance" "bastion_host_rs" {
  ami           = "ami-03d1b2fa19c17c9f1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "BastionHostRS"
  }
}

# EC2 Instance Resource
resource "aws_instance" "private_vm-rs-school" {
  ami           = "ami-008d05461f83df5b1"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  key_name = "rs-school-eu"

  tags = {
    Name = "Private-rs-school"
  }
}


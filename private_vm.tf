# EC2 Instance Resource
resource "aws_instance" "private_vm-rs-school" {
  ami           = "ami-0990f25dae5f0ae14"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  key_name = "rs-school-eu"  # Replace with the SSH key pair name

  tags = {
    Name = "Private-rs-school"  # Tags for easy identification
  }
}


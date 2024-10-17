resource "aws_instance" "private_vm_rs_school" {
  ami           = "ami-0990f25dae5f0ae14"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name      = var.key_name

  tags = {
    Name = "Private-rs-school"
  }
}

resource "aws_instance" "multiple_instances" {
  count         = 3
  ami           = "ami-0990f25dae5f0ae14"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true

  tags = {
    Name = "rs-school-${count.index}"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.bastion_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name      = "your-key-pair" # Replace with your key pair name

  tags = {
    Name = "bastion-host"
  }
}
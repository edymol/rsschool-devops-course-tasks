resource "aws_instance" "multiple_instances" {
  count         = 3                         # Creates 3 instances
  ami           = "ami-0990f25dae5f0ae14"
instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true

  tags = {
    Name = "rs-school-${count.index}"        # Each instance will get a unique tag
  }
}

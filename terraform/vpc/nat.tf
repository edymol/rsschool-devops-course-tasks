resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}

# # Cheaper Way: NAT Instance (Comment out NAT Gateway if using this)
# resource "aws_instance" "nat_instance" {
#   ami           = "ami-0f33411e8740e3c70" # Amazon Linux 2, x86_64
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.public[0].id
#   vpc_security_group_ids = [aws_security_group.public_sg.id]
#   source_dest_check = false
#
#   tags = {
#     Name = "nat-instance"
#   }
# }
#
# resource "aws_route" "private_nat" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gw.id
#   # Uncomment and comment nat_gateway_id if using NAT Instance
#   # instance_id            = aws_instance.nat_instance.id
# }
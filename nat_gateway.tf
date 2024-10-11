# nat_gateway.tf
resource "aws_eip" "nat_eip" {
  domain = "vpc"  # Use domain attribute instead of vpc = true because it is deprecated
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

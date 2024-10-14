# nat_gateway.tf
resource "aws_eip" "nat_eip" {
  # No need to define domain, it will be handled by AWS.
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

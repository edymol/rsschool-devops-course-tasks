# Remove or comment out the Bastion Host resource completely if it's not needed
# resource "aws_instance" "bastion" {
#   ami           = var.bastion_ami
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.public_subnet_1.id
#   security_groups = [aws_security_group.public_sg_rs.id]
#
#   tags = {
#     Name = "BastionHost"
#   }
# }

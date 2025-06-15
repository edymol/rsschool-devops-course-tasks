# infrastructure/terraform/ec2/main.tf
resource "aws_instance" "k3s_node" {
  count                  = 2 # Two nodes for a basic cluster (Free Tier eligible)
  ami                    = var.ec2_ami_id
  instance_type          = "t2.micro" # Free Tier eligible
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.private_security_group_id]
  key_name               = var.bastion_key_name
  associate_public_ip_address = false # Private subnet, access via bastion

  user_data = <<-EOF
              #!/bin/bash
              curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
              EOF

  tags = {
    Name = "${var.project_name}-k3s-node-${count.index + 1}"
  }
}

output "k3s_node_private_ips" {
  value = aws_instance.k3s_node[*].private_ip
}
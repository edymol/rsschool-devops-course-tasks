resource "aws_instance" "k3s_server" {
  count                       = 1
  ami                         = var.ec2_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.private_subnet_ids[0]
  vpc_security_group_ids      = [var.private_security_group_id]
  key_name                    = var.bastion_key_name
  associate_public_ip_address = false
  user_data                   = <<-EOF
#!/bin/bash
apt update -y
apt install -y python3-pip apt-transport-https ca-certificates curl gnupg2 software-properties-common
EOF
  tags                        = { Name = "${var.project_name}-k3s-server-1" }
}
resource "null_resource" "k3s_token_retriever" {
  depends_on = [aws_instance.k3s_server]
  provisioner "remote-exec" {
    script = "${path.module}/scripts/get_k3s_token.sh"
    connection {
      type        = "ssh"
      host        = aws_instance.k3s_server[0].private_ip
      user        = "ubuntu"
      private_key = file(var.bastion_key_path)
      agent       = false
      timeout     = "10m"
    }
  }
  triggers = { server_id = aws_instance.k3s_server[0].id }
}
data "external" "k3s_server_token" {
  program = ["bash", "-c", "${path.module}/scripts/get_k3s_token.sh"]
}
resource "aws_instance" "k3s_agent" {
  count                       = 1
  ami                         = var.ec2_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.private_subnet_ids[1]
  vpc_security_group_ids      = [var.private_security_group_id]
  key_name                    = var.bastion_key_name
  associate_public_ip_address = false
  depends_on                  = [aws_instance.k3s_server, null_resource.k3s_token_retriever]
  user_data                   = <<-EOF
#!/bin/bash
apt update -y
apt install -y python3-pip apt-transport-https ca-certificates curl gnupg2 software-properties-common
EOF
  tags                        = { Name = "${var.project_name}-k3s-agent-1" }
}
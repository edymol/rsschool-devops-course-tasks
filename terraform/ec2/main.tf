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
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.28.6+k3s1 sh -s - server --disable=traefik
  EOF
  tags                        = { Name = "${var.project_name}-k3s-server-1" }
}

resource "null_resource" "k3s_token_retriever" {
  depends_on = [aws_instance.k3s_server]
  provisioner "remote-exec" {
    script = "${path.module}/get_k3s_token.sh"
    connection {
      type        = "ssh"
      host        = aws_instance.k3s_server[0].private_ip
      user        = "ubuntu"
      private_key = file(var.bastion_key_path)
      agent       = false
      timeout     = "10m"
    }
  }
  provisioner "local-exec" {
    command = "echo '{\"token\": \"$(ssh -i ${var.bastion_key_path} ubuntu@${aws_instance.k3s_server[0].private_ip} cat /var/lib/rancher/k3s/server/node-token)\"}' > token.json"
  }
  triggers = { server_id = aws_instance.k3s_server[0].id }
}

data "external" "k3s_server_token" {
  program = ["cat", "${path.module}/token.json"]
  depends_on = [null_resource.k3s_token_retriever]
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
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.28.6+k3s1 sh -s - agent --server https://${aws_instance.k3s_server[0].private_ip}:6443 --token ${data.external.k3s_server_token.result.token}
  EOF
  tags                        = { Name = "${var.project_name}-k3s-agent-1" }
}
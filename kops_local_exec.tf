resource "null_resource" "run_kops_create_cluster" {
  provisioner "local-exec" {
    command = <<EOT
      export KOPS_STATE_STORE=$(terraform output -raw kops_state_store)
      export NAME=cluster.k8s.yourdomain.com  # Replace with your actual domain

      kops create cluster --name=$${NAME} --state=$${KOPS_STATE_STORE} \
      --zones=eu-west-1a \
      --master-size=t2.micro --node-size=t2.micro --node-count=3 \
      --dns-zone=$(terraform output -raw kops_dns_zone) --yes
    EOT
  }

  provisioner "local-exec" {
    command = <<EOT
      export KOPS_STATE_STORE=$(terraform output -raw kops_state_store)
      export NAME=cluster.k8s.yourdomain.com  # Replace with your actual domain

      kops validate cluster --name=$${NAME}
    EOT
  }

  depends_on = [
    aws_s3_bucket.kops_state_store,
    aws_route53_zone.kops_dns_zone
  ]
}

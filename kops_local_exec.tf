resource "null_resource" "run_kops_create_and_export" {
  provisioner "local-exec" {
    command = <<EOT
      # Set KOPS_STATE_STORE variable
      export KOPS_STATE_STORE=s3://terraform-rs-school-state-devops-bucket-k8-1
      NAME=cluster.k8s.local  # Using local DNS (gossip-based DNS)

      # Ensure the ~/.kube directory exists
      if [ ! -d ~/.kube ]; then
          mkdir -p ~/.kube
      fi

      # Create the cluster using gossip-based DNS
      kops create cluster --name=$${NAME} --state=$${KOPS_STATE_STORE} \
        --zones=eu-west-1a,eu-west-1b \
        --control-plane-size=t2.micro --node-size=t2.micro --node-count=3 \
        --dns private --yes

      # Export kubeconfig to access the cluster
      kops export kubecfg --name=$${NAME} --state=$${KOPS_STATE_STORE} --kubeconfig=~/.kube/config
    EOT
  }

  provisioner "local-exec" {
    command = <<EOT
      # Set KOPS_STATE_STORE variable
      export KOPS_STATE_STORE=s3://terraform-rs-school-state-devops-bucket-k8-1
      NAME=cluster.k8s.local

      # Validate the cluster
      kops validate cluster --name=$${NAME} --state=$${KOPS_STATE_STORE}

      # Ensure kubeconfig is in the default location
      if [ ! -f ~/.kube/config ]; then
        echo "Error: ~/.kube/config does not exist. Exiting."
        exit 1
      fi
    EOT
  }

  depends_on = [
    aws_s3_bucket.example  # Update this to reference the correct bucket
  ]
}

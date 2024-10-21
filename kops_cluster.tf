# resource "aws_s3_bucket" "kops_state_store" {
#   bucket = "kops-state-store-rs-school"
#
#   tags = {
#     Name = "Kops State Store"
#   }
# }

# Use a separate resource to handle versioning
# resource "aws_s3_bucket_versioning" "kops_state_store_versioning" {
#   bucket = aws_s3_bucket.kops_state_store.bucket
#
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# Route53 Hosted Zone for kOps cluster
resource "aws_route53_zone" "kops_dns_zone" {
  name = "k8s.digiaxix.com"
  tags = {
    Name = "K8s DNS Zone"
  }
}

# IAM role and policy for kOps cluster management
resource "aws_iam_role" "kops_role" {
  name = "kops-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kops_role_attach" {
  role       = aws_iam_role.kops_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

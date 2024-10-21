# iam.tf

# IAM Role for kOps Cluster Management
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

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "kops_role_attach" {
  role       = aws_iam_role.kops_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

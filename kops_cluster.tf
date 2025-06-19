#
#
# # Route53 Hosted Zone for kOps cluster
# resource "aws_route53_zone" "kops_dns_zone" {
#   name = "k8s.digiaxix.com"
#   tags = {
#     Name = "K8s DNS Zone"
#   }
# }
#
# resource "aws_iam_role_policy_attachment" "kops_role_attach" {
#   role       = aws_iam_role.kops_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }

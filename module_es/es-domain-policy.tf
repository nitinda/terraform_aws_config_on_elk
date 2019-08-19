resource "aws_elasticsearch_domain_policy" "demo_elasticsearch_domain_policy" {
  domain_name = "${aws_elasticsearch_domain.demo_elasticsearch_domain.domain_name}"

# Cognito Integration
#   access_policies = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "es:*",
#       "Principal": {
#         "AWS": [
#           "${var.cognito_iam_role_arn}"
#         ]
#       },
#       "Effect": "Allow",
#       "Resource": [
#         "${aws_elasticsearch_domain.demo_elasticsearch_domain.arn}/*"
#       ]
#     }
#   ]
# }
# POLICY

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "es:*"
      ],
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": [
            "${local.workstation_external_cidr}"
          ]
        }
      },
      "Resource": [
        "${aws_elasticsearch_domain.demo_elasticsearch_domain.arn}/*"
      ]
    }
  ]
}
POLICY
}
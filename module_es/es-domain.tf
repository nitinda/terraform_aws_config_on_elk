resource "aws_elasticsearch_domain" "demo_es_domain" {
  domain_name           = "terraform-demo-es-domain"
  elasticsearch_version = "6.7"

  cluster_config {
    instance_type  = "t2.small.elasticsearch"
    instance_count = 2
    dedicated_master_enabled = true
    zone_awareness_enabled = true
    dedicated_master_type = "t2.small.elasticsearch"
    dedicated_master_count = 3
  }

  tags = "${var.common_tags}"

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  ebs_options {
      ebs_enabled = true
      volume_type = "gp2"
      volume_size = "10"
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Action": "es:*",
        "Principal": {
          "AWS": [
            "${var.cognito_iam_role_arn}"
          ]
        },
        "Effect": "Allow",
        "Resource": [
          "arn:aws:es:${data.aws_region.demo_current.name}:${data.aws_caller_identity.demo_current.account_id}:domain/terraform*"
        ]
      }
    ]
}
POLICY

  depends_on = ["aws_iam_service_linked_role.demo_iam_service_linked_role_es"]

  cognito_options = {
    enabled          = true
    user_pool_id     = "${var.cognito_user_pool_id}"
    identity_pool_id = "${var.cognito_identity_pool_id}"
    role_arn         = "${aws_iam_role.demo_iam_role_es.arn}"
  }
}
resource "aws_elasticsearch_domain" "demo_elasticsearch_domain" {
  domain_name           = "terraform-demo-es-domain"
  elasticsearch_version = "7.1"

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

  depends_on = ["aws_iam_service_linked_role.demo_iam_service_linked_role_elasticsearch"]

  # cognito_options = {
  #   enabled          = true
  #   user_pool_id     = "${var.cognito_user_pool_id}"
  #   identity_pool_id = "${var.cognito_identity_pool_id}"
  #   role_arn         = "${aws_iam_role.demo_iam_role_es.arn}"
  # }
}
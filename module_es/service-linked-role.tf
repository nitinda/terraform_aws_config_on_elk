resource "aws_iam_service_linked_role" "demo_iam_service_linked_role_elasticsearch" {
  aws_service_name = "es.amazonaws.com"
}
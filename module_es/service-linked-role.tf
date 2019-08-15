resource "aws_iam_service_linked_role" "demo_iam_service_linked_role_es" {
  aws_service_name = "es.amazonaws.com"
}
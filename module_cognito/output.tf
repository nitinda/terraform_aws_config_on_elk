output "cognito_user_pool_id" {
  value = "${aws_cognito_user_pool.demo_cognoti_user_pool.id}"
}

output "cognito_identity_pool_id" {
  value = "${aws_cognito_identity_pool.demo_cognito_identity_pool.id}"
}

output "cognito_user_pool_endpoint" {
  value = "${aws_cognito_user_pool.demo_cognoti_user_pool.endpoint}"
}

output "cognito_iam_role_arn" {
  value = "${aws_iam_role.demo_iam_role_cognito.arn}"
}

output "cognito_identity_pool_roles_attachment_id" {
  value = "${aws_cognito_identity_pool_roles_attachment.demo_iam_role_attachment_cognito.id}"
}
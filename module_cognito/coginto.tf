resource "aws_cognito_user_pool" "demo_cognoti_user_pool" {
  name = "terraform-demo-cognito-user-pool"
  tags = "${var.common_tags}"
}

resource "aws_cognito_user_pool_domain" "demo_cognito_identity_pool_domain" {
  domain       = "tf-domain-${random_uuid.demo_random.result}"
  user_pool_id = "${aws_cognito_user_pool.demo_cognoti_user_pool.id}"
}

resource "aws_cognito_identity_pool" "demo_cognito_identity_pool" {
  identity_pool_name               = "terraform demo cognito identity pool"
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id               = "5n6vdp1m7uacsj7vopd7on6d6n"
    provider_name           = "${aws_cognito_user_pool.demo_cognoti_user_pool.endpoint}"
    server_side_token_check = true
  }
}
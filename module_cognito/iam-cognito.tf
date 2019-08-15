resource "aws_iam_role" "demo_iam_role_cognito" {
  name = "terraform-iam-role-cognito-authenticated"

  tags = "${var.common_tags}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito_identity.amazonaws.com:aud": "${aws_cognito_identity_pool.demo_cognito_identity_pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "demo_iam_role_policy_cognito" {
  name = "terraform-demo-iam-role-policy-cognito"
  role = "${aws_iam_role.demo_iam_role_cognito.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_cognito_identity_pool_roles_attachment" "demo_iam_role_attachment_cognito" {
  identity_pool_id = "${aws_cognito_identity_pool.demo_cognito_identity_pool.id}"

  roles = {
    "authenticated" = "${aws_iam_role.demo_iam_role_cognito.arn}"
  }
}
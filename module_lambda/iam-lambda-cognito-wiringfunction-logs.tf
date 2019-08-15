resource "aws_iam_role" "demo_iam_role_lambda_wiringfunction" {
  name = "terraform-demo-iam-role-lambda-wiringfunction"

  tags = "${var.common_tags}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "demo_iam_role_policy_lambda_wiringfunction" {
  name = "terraform-demo-iam-role-policy-lambda-wiringfunction"
  role = "${aws_iam_role.demo_iam_role_lambda_wiringfunction.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "cognito-sync:*",
          "cognito-identity:*",
          "cognito-idp:*"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:PutRetentionPolicy",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "es:*"
        ],
        "Resource": [
          "*"
        ]
      }
  ]
}
EOF
}


##############################################################################
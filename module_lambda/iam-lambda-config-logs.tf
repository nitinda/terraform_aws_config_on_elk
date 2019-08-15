##############################################################################

resource "aws_iam_role" "demo_iam_role_lambda_config_logstoelasticsearch" {
  name = "terraform-demo-iam-role-lambda-config-logstoelasticsearch"

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

resource "aws_iam_role_policy" "demo_iam_role_policy_lambda_config_logstoelasticsearch" {
  name = "terraform-demo-iam-role-policy-lambda-config-logstoelasticsearch"
  role = "${aws_iam_role.demo_iam_role_lambda_config_logstoelasticsearch.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": "es:ESHttpPost",
            "Resource": "arn:aws:es:*:*:*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "demo_iam_role_policy_attachment_AWSLambdaVPCAccessExecutionRole" {
  role       = "${aws_iam_role.demo_iam_role_lambda_config_logstoelasticsearch.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_iam_role_policy_attachment" "demo_iam_role_policy_attachment_AmazonS3ReadOnlyAccess" {
  role       = "${aws_iam_role.demo_iam_role_lambda_config_logstoelasticsearch.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
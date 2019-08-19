resource "aws_iam_role" "demo_iam_role_elasticsearch" {
  name = "terraform-demo-iam-role-elasticsearch"
  path = "/service-role/"

  tags = "${merge(var.common_tags, map(
    "Description", "IAM Role for Elasticsearch Domains",
  ))}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "demo_iam_role_policy_elasticsearch" {
  name = "terraform-demo-iam-role-policy-elasticsearch"
  role = "${aws_iam_role.demo_iam_role_elasticsearch.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVpcs",
        "cognito-identity:ListIdentityPools",
        "cognito-idp:ListUserPools"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:PassRole"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "demo_iam_role_policy_elasticsearch_attachment_AmazonESCognitoAccess" {
  role       = "${aws_iam_role.demo_iam_role_elasticsearch.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonESCognitoAccess"
}
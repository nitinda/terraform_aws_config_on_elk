output "lambda_function_config_logstoelasticsearch_arn" {
  value = "${aws_lambda_function.demo_lambda_config_logstoelasticsearch.arn}"
}

output "lambda_cwlpolicyforstreaming_role_arn" {
  value = "${aws_iam_role.demo_iam_role_lambda_wiringfunction.arn}"
}

resource "aws_s3_bucket_notification" "demo_s3_bucket_notification_lambda_config_logstoelasticsearch" {
  bucket = "${var.s3_bucket_name}"

  lambda_function {
    lambda_function_arn = "${var.config_logstoelasticsearch_lambda_function_arn}"
    events              = ["s3:ObjectCreated:Put"]
  }
}
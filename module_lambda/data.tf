data "archive_file" "demo_archive_file_lambda_config_logstoelasticsearch" {
  type        = "zip"
  source_file = "${path.module}/lambda_function/lambda-config-logstoelasticsearch/index.py"
  output_path = "${path.module}/lambda_function/archive/terraform-demo-lambda-config-logstoelasticsearch.zip"
}

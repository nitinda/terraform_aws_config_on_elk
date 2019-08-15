resource "aws_lambda_function" "demo_lambda_config_logstoelasticsearch" {
    filename         = "../module_lambda/lambda_function/terraform-demo-lambda-config-logstoelasticsearch.zip"
    function_name    = "terraform-demo-lambda-config-logstoelasticsearch"
    description      = "CloudWatch Logs to Amazon ES streaming"
    role             = "${aws_iam_role.demo_iam_role_lambda_config_logstoelasticsearch.arn}"
    handler          = "index.lambda_handler"
    source_code_hash = "${filebase64sha256("../module_lambda/lambda_function/terraform-demo-lambda-config-logstoelasticsearch.zip")}"
    runtime          = "python3.7"
    timeout          = "600"
    memory_size      = "128"

    environment {
        variables = {
            ES_HOST = "${var.es_endpoint}"
            INDEX_PREFIX = "config-"
        }
    }

    layers = ["${var.lambda_layer_python_arn}"]

    tags = "${var.common_tags}"
}
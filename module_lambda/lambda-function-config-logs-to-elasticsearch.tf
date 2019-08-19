resource "aws_lambda_function" "demo_lambda_config_logstoelasticsearch" {
    filename         = "${data.archive_file.demo_archive_file_lambda_config_logstoelasticsearch.output_path}"
    function_name    = "terraform-demo-lambda-config-logstoelasticsearch"
    description      = "AWS Config Snapshot data to Amazon ES streaming"
    role             = "${aws_iam_role.demo_iam_role_lambda_config_logstoelasticsearch.arn}"
    handler          = "index.lambda_handler"
    source_code_hash = "${data.archive_file.demo_archive_file_lambda_config_logstoelasticsearch.output_base64sha256}"
    runtime          = "python3.7"
    timeout          = "600"
    memory_size      = "512"

    environment {
        variables = {
            ES_HOST = "${var.es_endpoint}"
            INDEX_PREFIX = "config-"
        }
    }

    layers = ["${var.lambda_layer_python_arn}"]

    tags = "${var.common_tags}"
}
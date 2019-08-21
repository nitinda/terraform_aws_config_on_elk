resource "aws_lambda_layer_version" "demo_lambda_layer_python3" {
    description = "Terraform demo lambda layer for python3.7 support site-packges"
    filename   = "${data.archive_file.demo_archive_file_lambda_layer_payload.output_path}"
    layer_name = "terraform-demo-lambda-layer-payload-python3"
    compatible_runtimes = ["python3.7","python3.6"]
    source_code_hash = "${data.archive_file.demo_archive_file_lambda_layer_payload.output_base64sha256}"
}
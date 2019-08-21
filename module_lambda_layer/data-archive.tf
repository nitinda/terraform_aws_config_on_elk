data "archive_file" "demo_archive_file_lambda_layer_payload" {
  type        = "zip"
  source_dir  = "${path.module}/python_layers_payload/"
  output_path = "${path.module}/archive_lambda_layer/terraform-demo-python-lambda-layer-payload.zip"
  depends_on  = ["null_resource.demo_null_resource_pip_download_modules"]
}

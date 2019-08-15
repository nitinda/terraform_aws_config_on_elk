resource "aws_lambda_layer_version" "demo_lambda_layer_python3" {
    description = "Terraform demo lambda layer for python3.7 support site-packges"
    filename   = "${path.module}/python_layers_payload/terraform-demo-python3.7-lambda-layer-payload.zip"
    layer_name = "terraform-demo-lambda-layer-payload-python3"
    compatible_runtimes = ["python3.7","python3.6"]
    source_code_hash = "${base64sha256(file("${path.module}/python_layers_payload/terraform-demo-python3.7-lambda-layer-payload.zip"))}"
}
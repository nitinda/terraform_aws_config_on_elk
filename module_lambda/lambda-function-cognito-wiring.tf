resource "aws_lambda_function" "demo_lambda_wiringfunction" {
    filename         = "../module_lambda/lambda_function/terraform-demo-lambda-wiringfunction.zip"
    function_name    = "terraform-demo-lambda-wiringfunction"
    description      = "Wires together Cognito and Amazon ES"
    role             = "${aws_iam_role.demo_iam_role_lambda_wiringfunction.arn}"
    handler          = "index.handler"
    source_code_hash = "${filebase64sha256("../module_lambda/lambda_function/terraform-demo-lambda-wiringfunction.zip")}"
    runtime          = "python2.7"
    timeout          = "60"
    memory_size      = "128"
    
    environment {
        variables = {
            COGNITOUSERPOOL = "${var.cognito_user_pool_id}"
        }
    }

    tags = "${var.common_tags}"
}
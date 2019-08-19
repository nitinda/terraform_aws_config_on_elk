terraform {
  required_version = ">= 0.11.7"
}

module "aws_resources_module_network" {
  source  = "../module_network"

  providers = {
    "aws"  = "aws.shared_services"
  }
  common_tags = "${var.common_tags}"
}

# module "aws_resources_module_cognito" {
#   source  = "../module_cognito"

#   providers = {
#     "aws"  = "aws.shared_services"
#   }
#   common_tags = "${var.common_tags}"
# }

module "aws_resources_module_es" {
  source  = "../module_es"

  providers = {
    "aws"  = "aws.shared_services"
  }

  common_tags = "${var.common_tags}"
  es_subnet_ids = "${module.aws_resources_module_network.demo_subnet_public}"
  security_group_ids = "${module.aws_resources_module_network.demo_security_group}"
  # cognito_user_pool_id = "${module.aws_resources_module_cognito.cognito_user_pool_id}"
  # cognito_user_pool_endpoint = "${module.aws_resources_module_cognito.cognito_user_pool_endpoint}"
  # cognito_identity_pool_id = "${module.aws_resources_module_cognito.cognito_identity_pool_id}"
  # cognito_iam_role_arn = "${module.aws_resources_module_cognito.cognito_iam_role_arn}"
  # depends_on = ["${module.aws_resources_module_cognito.cognito_identity_pool_roles_attachment_id}"]
}

module "aws_resources_module_lambda_layer" {
  source  = "../module_lambda_layer"

  providers = {
    "aws"  = "aws.shared_services"
  }
}

module "aws_resources_module_lambda" {
  source  = "../module_lambda"

  providers = {
    "aws"  = "aws.shared_services"
  }
  
  common_tags = "${var.common_tags}"
  # cognito_user_pool_id = "${module.aws_resources_module_cognito.cognito_user_pool_id}"
  es_endpoint = "${module.aws_resources_module_es.es_endpoint}"
  lambda_layer_python_arn = "${module.aws_resources_module_lambda_layer.demo_lambda_layer_python3_version_arn}"
  
  depends_on = ["${module.aws_resources_module_lambda_layer.demo_lambda_layer_python3_version_arn}"]
}

# module "aws_resources_module_s3_events" {
#   source  = "../module_s3_events"

#   providers = {
#     "aws"  = "aws.shared_services"
#   }

#   common_tags = "${var.common_tags}"
#   s3_bucket_name = "${module.aws_resources_module_s3.s3_bucket_name}"
#   config_logstoelasticsearch_lambda_function_arn = "${module.aws_resources_module_lambda.lambda_function_config_logstoelasticsearch_arn}"
# }
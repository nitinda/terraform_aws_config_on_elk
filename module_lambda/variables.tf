# variable "cognito_user_pool_id" {
#   description = "description"
# }

variable "es_endpoint" {
  description = "description"
}

variable depends_on { default = [], type = "list"}

variable "lambda_layer_python_arn" {
  description = "The Amazon Resource Name (ARN) of the Lambda Layer with version"  
}

variable common_tags {
  description = "Reource Tags"
  type = "map"
}
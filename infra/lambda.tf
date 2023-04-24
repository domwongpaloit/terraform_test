module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "hello-world-${var.stage}"
  description   = "Lambda test module"
  handler       = "hello.handler"
  runtime       = "nodejs16.x"
  publish       = true
  source_path   = "../backend/src/"
  store_on_s3   = true
  s3_bucket     = aws_s3_bucket.lambda_bucket.id

  #   layers = [
  #     module.lambda_layer_s3.lambda_layer_arn,
  #   ]
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
  environment_variables = {
    "Serverless" = "Terraform"
  }
}

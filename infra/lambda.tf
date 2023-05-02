locals {
  lambda_functions = [
    {
      function_name = "hello"
      handler       = "hello.handler"
      runtime       = "nodejs16.x"
    },
    {
      function_name = "getsomething"
      handler       = "getsomething.handler"
      runtime       = "nodejs16.x"
    }
  ]
}

module "lambda_functions" {
  source = "terraform-aws-modules/lambda/aws"

  for_each = { for fn in local.lambda_functions : fn.function_name => fn }

  function_name = "${each.value.function_name}-${var.stage}"
  description   = "Lambda test module"
  handler       = each.value.handler
  runtime       = each.value.runtime
  publish       = true
  source_path   = "../backend/src/${each.value.function_name}.js"
  store_on_s3   = true
  s3_bucket     = aws_s3_bucket.lambda_bucket.id

  layers = [
    module.lambda_layer_s3.lambda_layer_arn,
  ]

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
  environment_variables = {
    "Serverless" = "Terraform",
    "my_secret"  = local.secrets.my_secret
  }
  tags = {
    "stage" : "${var.stage}",
    "app" : "${var.app_name}"

  }
}

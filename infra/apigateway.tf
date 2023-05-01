# Define the API Gateway REST API
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  create_api_domain_name = false
  name                   = "hello-world-v2-${var.stage}"

  integrations = {
    "GET /hello" = {
      lambda_arn = module.lambda_functions["hello"].lambda_function_arn
    },
    "GET /getsomething" = {
      lambda_arn = module.lambda_functions["getsomething"].lambda_function_arn
    }
  }

  tags = {
    Name = "${var.stage}"
  }
}

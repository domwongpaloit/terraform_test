# Define the API Gateway REST API
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  create_api_domain_name = false
  name                   = "hello-world-v2-${var.stage}"

  body = templatefile("../doc/openapi.yaml", {
    hello_function_arn        = module.lambda_functions["hello"].lambda_function_arn,
    getsomething_function_arn = module.lambda_functions["getsomething"].lambda_function_arn
    posts_function_arn        = module.lambda_functions["posts"].lambda_function_arn
  })

  tags = {
    Name = "${var.stage}"
  }
}

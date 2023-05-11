# Define the API Gateway REST API
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  create_api_domain_name = false
  name                   = "hello-world-v2-${var.stage}"

  body = templatefile("../doc/openapi.yaml", {
    # example of blue green with code deploy for hello function
    hello_function_arn        = "${module.lambda_functions["hello"].lambda_function_arn}:current",
    getsomething_function_arn = module.lambda_functions["getsomething"].lambda_function_arn
    posts_function_arn        = module.lambda_functions["posts"].lambda_function_arn
  })

  tags = {
    Name = "${var.stage}"
  }
}

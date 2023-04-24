# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.aws_region
}


resource "random_pet" "lambda_bucket_name" {
  prefix = "terraform-lambda-test"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

# Define the API Gateway REST API
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  create_api_domain_name = false
  name                   = "hello-world-v2-${var.stage}"

  integrations = {
    "GET /hello" = {
      lambda_arn = module.lambda_function.lambda_function_arn
    }
  }

  tags = {
    Name = "${var.stage}"
  }
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "hello-world-${var.stage}"
  description   = "Lambda test module"
  handler       = "hello.handler"
  runtime       = "nodejs16.x"
  publish       = true

  source_path = "../backend/src/"
  store_on_s3 = true
  s3_bucket   = aws_s3_bucket.lambda_bucket.id

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

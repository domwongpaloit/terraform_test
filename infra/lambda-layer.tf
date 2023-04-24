

# module "lambda_layer_s3" {
#   source              = "terraform-aws-modules/lambda/aws"
#   create_layer        = true
#   layer_name          = "lambda-layer-s3"
#   description         = "Layer description"
#   compatible_runtimes = ["nodejs16.x"]
#   source_path         = "../backend"
#   store_on_s3         = true
#   s3_bucket           = aws_s3_bucket.lambda_bucket.id
# }

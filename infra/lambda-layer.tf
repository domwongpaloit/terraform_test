
module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "my-layer-s3-${var.stage}"
  description         = "My amazing lambda layer (deployed from S3)"
  compatible_runtimes = ["nodejs16.x"]

  source_path = "../${path.module}/backend/layer"

  store_on_s3 = true
  s3_bucket   = aws_s3_bucket.lambda_bucket.id
}

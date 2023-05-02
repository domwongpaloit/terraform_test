data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "arn:aws:secretsmanager:us-east-1:648143227810:secret:my_secret_test-0TGCDT"
}

locals {
  secrets = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

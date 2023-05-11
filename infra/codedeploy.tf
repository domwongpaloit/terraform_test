
module "alias_refresh" {
  source  = "terraform-aws-modules/lambda/aws//modules/alias"
  version = "4.7.0"

  refresh_alias = true

  name = "current"

  function_name = module.lambda_functions["hello"].lambda_function_name

  # Set function_version when creating alias to be able to deploy using it,
  # because AWS CodeDeploy doesn't understand $LATEST as CurrentVersion.
  function_version = module.lambda_functions["hello"].lambda_function_version


  allowed_triggers = {
    AotherAPIGatewayAny = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }

}

module "deploy" {
  depends_on = [module.alias_refresh]
  source     = "terraform-aws-modules/lambda/aws//modules/deploy"
  version    = "4.7.0"

  alias_name    = module.alias_refresh.lambda_alias_name
  function_name = module.lambda_functions["hello"].lambda_function_name

  target_version = module.lambda_functions["hello"].lambda_function_version
  description    = "This is my awesome deploy!"

  create_app = true
  app_name   = "${module.lambda_functions["hello"].lambda_function_name}-app"

  create_deployment_group = true
  deployment_group_name   = "${module.lambda_functions["hello"].lambda_function_name}-deployment-group"
  deployment_config_name  = "CodeDeployDefault.LambdaLinear10PercentEvery1Minute"

  create_deployment          = true
  run_deployment             = true
  save_deploy_script         = true
  wait_deployment_completion = true
  force_deploy               = true

  attach_triggers_policy = true
  triggers = {
    start = {
      events     = ["DeploymentStart"]
      name       = "DeploymentStart"
      target_arn = aws_sns_topic.sns1.arn
    }
    success = {
      events     = ["DeploymentSuccess"]
      name       = "DeploymentSuccess"
      target_arn = aws_sns_topic.sns2.arn
    }
  }

}

# Comment out for applying all function in code deploy


# module "alias" {
#   source = "terraform-aws-modules/lambda/aws//modules/alias"

#   for_each = { for fn in local.lambda_functions : fn.function_name => fn }
#   name     = "current"

#   function_name    = module.lambda_functions[each.value.function_name].lambda_function_name
#   function_version = module.lambda_functions[each.value.function_name].lambda_function_version

#   allowed_triggers = {
#     AotherAPIGatewayAny = {
#       service    = "apigateway"
#       source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
#     }
#   }
# }

# module "deploy" {
#   source   = "terraform-aws-modules/lambda/aws//modules/deploy"
#   for_each = { for fn in local.lambda_functions : fn.function_name => fn }

#   alias_name     = module.alias[each.value.function_name].lambda_alias_name
#   function_name  = module.lambda_functions[each.value.function_name].lambda_function_name
#   target_version = module.lambda_functions[each.value.function_name].lambda_function_version

#   create_app = true
#   app_name   = "${module.lambda_functions[each.value.function_name].lambda_function_name}-app"

#   create_deployment_group = true
#   deployment_group_name   = "${module.lambda_functions[each.value.function_name].lambda_function_name}-deployment-group"

#   create_deployment          = true
#   run_deployment             = true
#   wait_deployment_completion = true
#   force_deploy               = true
#   attach_triggers_policy     = true
#   deployment_config_name     = "CodeDeployDefault.LambdaAllAtOnce"
#   triggers = {
#     start = {
#       events     = ["DeploymentStart"]
#       name       = "DeploymentStart"
#       target_arn = aws_sns_topic.sns1.arn
#     }
#     success = {
#       events     = ["DeploymentSuccess"]
#       name       = "DeploymentSuccess"
#       target_arn = aws_sns_topic.sns2.arn
#     }
#   }
# }

resource "random_pet" "this" {
  length = 2
}
resource "aws_sns_topic" "sns1" {
  name_prefix = random_pet.this.id
}

resource "aws_sns_topic" "sns2" {
  name_prefix = random_pet.this.id
}

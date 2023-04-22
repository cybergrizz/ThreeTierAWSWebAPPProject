#####WEB APPLICATION FIREWALL#####

resource "aws_wafv2_rule_group" "webapp_fw" {
  name     = var.waf_name
  scope    = var.waf_scope
  capacity = 2

  rule {
    name     = "rule-1"
    priority = 1

    action {
      allow {}
    }

    statement {

      geo_match_statement {
        country_codes = ["US", "NL"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.cw_enabled_boolean
      metric_name                = var.cloudwatch_metric_rule_name
      sampled_requests_enabled   = var.sr_enabled_boolean
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cw_enabled_boolean
    metric_name                = var.cloudwatch_metric_name
    sampled_requests_enabled   = var.sr_enabled_boolean
  }
}



#####COGNITO#####
resource "aws_cognito_user_pool" "cognito-pool" {
  name                     = var.cognito_name
  auto_verified_attributes = ["email"]

  mfa_configuration          = var.mfa_configuration
  sms_authentication_message = var.mfa_sms_message

  sms_configuration {
    external_id    = var.sms_id
    sns_caller_arn = aws_iam_role.cognito-role.arn
    sns_region     = var.region
  }

  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = var.recovery_mechanism_1
      priority = 1
    }

    recovery_mechanism {
      name     = var.recovery_mechanism_2
      priority = 2
    }
  }
}

resource "aws_cognito_identity_provider" "cognito-provider" {
  user_pool_id  = aws_cognito_user_pool.cognito-pool.id
  provider_name = var.provider_name_cog
  provider_type = var.provider_type_cog

}

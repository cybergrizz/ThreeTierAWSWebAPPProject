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



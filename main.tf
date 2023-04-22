#####STATIC WEBSITE STORED HERE#####
resource "aws_s3_bucket_website_configuration" "web-app" {
  bucket = var.bucket_name

  tags = {
    name = "Web App"
  }
}

resource "aws_s3_bucket_acl" "bucker_acl" {
  bucket = [aws_s3_bucket.web-app.id]
  acl    = "private"

}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.web-app.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

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

####IAM ROLE COGNITO####

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.cognito-role.id


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "cognito_role" {
  name = var.iam_cognito_name


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}




#####AUTO-SCALING GROUP#####
resource "aws_launch_template" "alt-asg" {
  name                = var.asg_name
  image_id            = var.ami
  instance_type       = var.instance_type
  vpc_security_groups = [aws_security_group.lt-sg.id]
}

resource "aws_autoscaling_group" "asg" {
  availability_zones  = [var.AZones]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [var.private_subnets, var.public_subnets]

  launch_template {
    id      = aws_launch_template.alt-asg.id
    version = "$Latest"
  }
}

#####SECURITY GROUP#####
resource "aws_security_group" "alb-sg" {
  name   = var.alb_sg_name
  vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.alb_sg_cidr_ingress
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.alb_sg_cidr_ingress
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.alb_sg_cidr_egress
  }

  tags = {
    Name = "alb-sg"
  }
}

#####LT-Security Group####

resource "aws_security_group" "lt-sg" {
  name   = var.lt_sg_name
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    from_port       = var.ssh_port
    to_port         = var.ssh_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.lt_sg_cidr_egress
  }

  tags = {
    Name = "lt-sg"
  }
}

#####LOAD BALANCER#####
resource "aws_lb" "pub-sub-alb" {
  name            = var.alb_name
  security_groups = [aws_security_group.lb-sg.id]
  subnets         = var.public_subnets

  tags = {
    name = "Pub-sub-alb"
  }
}

resource "aws_lb_target_group" "alb-tg" {
  name     = var.alb_tg_name
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform-vpc.id

  health_check {
    interval = 60
    path     = "/"
    port     = var.http_port
    protocol = "HTTP"
    timeout  = 30
    matcher  = "200,202"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.pub-sub-alb.arn
  port              = var.http_port
  protocol          = "HTTP"
  vpc_id            = aws_vpc.terraform-vpc.id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}




#####DOMAIN REGISTRATION#####
resource "aws_route53domains_registered_domain" "dns-name" {
  domain_name = var.domain_name
}

#####DATABASE TO STORE INFORMATION RECEIVED FROM WEB APPLICATION#####
resource "aws_db_instance" "db-instance" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_pass
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
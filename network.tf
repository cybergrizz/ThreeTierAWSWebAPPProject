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


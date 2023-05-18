variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "ec2 instance type"
}

variable "public_subnets" {
  default = {
    "public-subnet-1" = 1
    "public-subnet-2" = 2
  }
}

variable "private_subnets" {
  default = {
    "private-subnet-1" = 1
    "private-subnet-2" = 2
  }
}

variable "AZones" {
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b", ]
  description = "description"
}

variable "ami" {
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
  description = "Amazon machine image to use for ec2 instance"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "region"
}

variable "bucket_name" {
  type        = string
  description = "name of S3 bucket"
  default     = "dad-joke-generator"

}

variable "domain_name" {
  type        = string
  description = "name of S3 bucket"
  default     = "http://localhost:8082/"

}

variable "instance_name" {
  type        = string
  default     = "dad-joke-generator"
  description = "instance name"
}

variable "db_name" {
  type        = string
  default     = "dad-joke-generator"
  description = "db instance name"
}

variable "vpc_name" {
  type        = string
  default     = "dad-joke-generator-vpc"
  description = "dad joke vpc name"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "vpc cidr block id"
}

variable "asg_name" {
  type        = string
  default     = "dad-joke-asg"
  description = "dad joke asg name"
}

variable "sg_name" {
  type        = string
  default     = "dad-joke-sg"
  description = "security groups name"
}

variable "lt_sg_name" {
  type        = string
  default     = "dad-joke-lt-sg"
  description = "launch template security groups name"
}

variable "http_port" {
  type        = number
  default     = 80
  description = "HTTP port for sg access"
}

variable "ssh_port" {
  type        = number
  default     = 22
  description = "port nyumber for SSH access"
}

variable "tcp" {
  type        = string
  default     = "tcp"
  description = "TCP protocol"
}

variable "http" {
  type        = string
  default     = "HTTP"
  description = "Http protocol"
}

variable "egress-all" {
  type    = string
  default = "0"
}

variable "egress" {
  type    = string
  default = "-1"
}


variable "alb_name" {
  type        = string
  default     = "Dad-Joke-Load-Balancer"
  description = "Load balancer for Web App"
}

variable "alb_tg_name" {
  type        = string
  default     = "Dad-Joke-ALB-TG"
  description = "name for ALB target group"
}

variable "waf_name" {
  type        = string
  default     = "Dad-Joke-WAF"
  description = "Name of Dad Joke WAF"
}

variable "waf_scope" {
  type        = string
  default     = "CLOUDFRONT"
  description = "WAF Scope"
}

variable "cloudwatch_metric_rule_name" {
  type        = string
  default     = "Dad-Joke-CW-Metrics-For-Rule"
  description = "Metric name for CloudWatch Rule"
}

variable "cloudwatch_metric_name" {
  type        = string
  default     = "Dad-Joke-CW-Metrics"
  description = "Metric name for CloudWatch"
}
variable "cw_enabled_boolean" {
  default = true
}

variable "sr_enabled_boolean" {
  default = true
}

variable "db_username" {}

variable "db_password" {}

variable "tenancy" {
  type    = string
  default = "default"
}

variable "true" {
  type    = bool
  default = true
}

variable "cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "origin_access" {
  type        = string
  default     = "DJG-OAccess"
  description = "Origin access id for DJG"
}

variable "origin_access_type" {
  type        = string
  default     = "S3"
  description = "Origin access type for DJG"
}

variable "signing_behavior" {
  type        = string
  default     = "always"
  description = "Signing behavior for Clour Front"
}

variable "signing_protocol" {
  type        = string
  default     = "sigv4"
  description = "Signing protocol for Clour Front"
}
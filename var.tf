variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "ec2 instance type"
}

variable "public_subnets" {
  type        = list(any)
  default     = ["10.0.102.0/24", "10.0.103.0/24"]
  description = "VPC public subnet"
}

variable "private_subnets" {
  type        = list(any)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
  description = "VPC private subnet"
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

variable "db_username" {
  type        = string
  default     = "SilverFang88"
  description = "database username"
}

variable "db_pass" {
  type        = string
  default     = "RandonStrongPassword123456!!!"
  description = "database password"
}

variable "vpc_name" {
  type = string 
  default = "dad-joke-generator-vpc"
  description = "dad joke vpc name"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
  description = "vpc cidr block id"
}

variable "asg_name" {
  type = string 
  default = "dad-joke-asg"
  description = "dad joke asg name"
}

variable "alb_sg_name" {
  type = string 
  default = "dad-joke-sg"
  description = "security groups name"
}

variable "lt_sg_name" {
  type = string 
  default = "dad-joke-lt-sg"
  description = "launch template security groups name"
}

variable "http_port" {
  type = number 
  default = 80
  description = "HTTP port for sg access"
}

variable "ssh_port" {
  type = number 
  default = 22
  description = "port nyumber for SSH access"
}

variable "alb_sg_cidr_egress" {
  type = list (string)
  default = ["0.0.0.0/0"]
  description = "List of CIDR blocks for ALB SG Egress"
}

variable "alb_sg_cidr_ingress" {
  type = list (string)
  default = ["0.0.0.0/0"]
  description = "List of CIDR blocks for ALB SG Ingress"
}

variable "lt_sg_cidr_egress" {
  type = list (string)
  default = ["0.0.0.0/0"]
  description = "List of CIDR blocks for LT SG Egress"
}

variable "alb_name" {
  type        = string
  default     = "Dad Joke Load Balancer"
  description = "Load balancer for Web App"
}

variable "alb_tg_name" {
  type        = string
  default     = "Dad-Joke-ALB-TG"
  description = "name for ALB target group"
}

variable "waf_name" {
  type = string 
  default = "Dad-Joke-WAF"
  description = "Name of Dad Joke WAF"
}

variable "waf_scope" {
  type = string 
  default = "CLOUDFRONT"
  description = "WAF Scope"
}

variable "cloudwatch_metric_rule_name" {
  type = string 
  default = "Dad-Joke-CW-Metrics-For-Rule"
  description = "Metric name for CloudWatch Rule"
}

variable "cloudwatch_metric_name" {
  type = string 
  default = "Dad-Joke-CW-Metrics"
  description = "Metric name for CloudWatch"
}
variable "cw_enabled_boolean" {
  default = true
}

variable "sr_enabled_boolean" {
  default = true
}

variable "cognito_name" {
  type = string 
  default = "Dad-Joke_cognito_pool"
  description = "Name for Cognito pool"
}

variable "provider_type_cog" {
  type = string 
  default = "GOOGLE"
  description = "Provider type for Cognito Pool"
} 

variable "provider_name_cog" {
  type = string 
  default = "GOOGLE"
  description = "Provider name for Cognito"
}

variable "mfa_sms_message" {
  type = string 
  default = "Your code is {*********}"
  description = "Message code for MFA SMS"
}

variable "mfa_configuration" {
  type = string 
  default = "ON"
  description = "MFA configuration"
}

variable "sms_id" {
  type = string
  default = "Dad-Joke-SMS-iD"
  description = "SMS iD"
}

variable "recovery_mechanism_1" {
  type = string
  default = "verified_email"
  description = "1st Recovery path for account"
}

variable "recovery_mechanism_2" {
  type = string
  default = "verified_phone_number"
  description = "2nd Recovery path for account"
}

variable "iam_cognito_name" {
  type = string 
  default = "Dad-Joke-SMS-role"
  description = "IAM role for Cognito SMS"
}
#####STATIC WEBSITE STORED HERE#####
resource "aws_s3_bucket_website_configuration" "web-app" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = var.bucket_name
  acl    = "private"

}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_s3_bucket" "web-app" {
  bucket = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
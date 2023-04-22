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
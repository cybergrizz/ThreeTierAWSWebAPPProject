#####LT-Security Group####

resource "aws_security_group" "lt-sg" {
  name   = var.lt_sg_name
  vpc_id = aws_vpc.terraform-vpc.id

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
    cidr_blocks = [var.cidr]
  }

  tags = {
    Name = "lt-sg"
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
    cidr_blocks = [var.cidr]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr]
  }

  tags = {
    Name = "alb-sg"
  }
}

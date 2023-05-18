#####LT-Security Group####

resource "aws_security_group" "lt-sg" {
  name   = var.lt_sg_name
  vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = var.tcp
    security_groups = [aws_security_group.terraform-sg.id]
  }

  ingress {
    from_port       = var.ssh_port
    to_port         = var.ssh_port
    protocol        = var.tcp
    security_groups = [aws_security_group.terraform-sg.id]
  }

  egress {
    from_port   = var.egress-all
    to_port     = var.egress-all
    protocol    = var.egress
    cidr_blocks = [var.cidr]
  }


  tags = {
    Name = "lt-sg"
  }
}

#####SECURITY GROUP#####
resource "aws_security_group" "terraform-sg" {
  name   = var.sg_name
  vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.tcp
    cidr_blocks = [var.cidr]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.tcp
    cidr_blocks = [var.cidr]
  }

  egress {
    from_port   = var.egress-all
    to_port     = var.egress-all
    protocol    = var.egress
    cidr_blocks = [var.cidr]
  }
  
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "terraform-sg"
  }
}

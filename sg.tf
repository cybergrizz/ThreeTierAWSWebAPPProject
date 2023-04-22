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
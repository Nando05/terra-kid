resource "aws_instance" "this" {
  ami                    = "ami-08b5b3a93ed654d19"
  instance_type          = "t2.micro"
  user_data              = <<EOT
    #!/bin/bash
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
    EOT
  vpc_security_group_ids = [aws_security_group.web_access.id]
}


variable "vpc_id" {
  default = ""
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}


resource "aws_security_group" "web_access" {
  name        = "web_access"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = "allow_HTTP"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP_ipv4" {
  security_group_id = aws_security_group.web_access.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.web_access.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
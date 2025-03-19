resource "aws_instance" "this" {
  ami           = "ami-0dcc1e21636832c5d"
  instance_type = "t2.micro"
  user_data     = <<EOT
    #!/bin/bash
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
    EOT
}
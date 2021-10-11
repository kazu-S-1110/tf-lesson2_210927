resource "aws_instance" "server" {
  ami = "ami-0701e21c502689c31"
  instance_type = var.instance_type
  tags = {
    Name = "TestWebServer"
  }

  user_data = <<EOF
  #!/bin/bash
  amazon-linux-extras install -y nginx1.12
  systemctl start nginx
  EOF
}

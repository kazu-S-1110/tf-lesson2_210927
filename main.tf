provider "aws" {
  profile = "terraform-test_210927"
  region  = "ap-northeast-1"
}

resource "aws_instance" "hello-world" {
  ami           = "ami-02892a4ea9bfa2192" # amiはamazon machine imageの略
  instance_type = "t2.micro"

  tags = {
    Name = "Hello World"
  }

  #ec2インスタンスにnginxをインストールさせる
  user_data = <<EOF
#!/bin/bash
amazon-linux-extras install -y nginx1.12
systemctl start nginx
EOF
}

# -----------------------------------
# key pair
# -----------------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/tastylog-dev-keypair.pub")

  tags = {
    "Name"  = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# -----------------------------------
# ec2 instance
# -----------------------------------
# resource "aws_instance" "app_server" {
#   # aws_amiで検索したものを指定する
#   ami                         = data.aws_ami.app.id
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public_subnet_1a.id
#   associate_public_ip_address = true
#   #作成したIAMロールを適用
#   iam_instance_profile = aws_iam_instance_profile.app_ec2_profile.name
#   vpc_security_group_ids = [
#     aws_security_group.app_sg.id,
#     aws_security_group.opmng_sg.id,
#   ]
#   # keypairの参照名はkey_nameなので注意。詳しくはリファレンス見てね。
#   key_name = aws_key_pair.keypair.key_name

#   tags = {
#     "Name"  = "${var.project}-${var.environment}-app-ec2"
#     Project = var.project
#     Env     = var.environment
#     Type    = "app"
#   }
# }

# aws_instanceの取り込み方法 (cmd:terraform import aws_instance.test [id])
#もしtfstateをs3保存している場合にはterraform importの結果はs3へ反映される。
#ローカルでも合わせたい場合にはterraform state show hoge をして中身を確認してローカルに反映させる必要あり
#ちゃんとローカルとs3のtfstateに違いがないか確認するにはterraform planを叩いてno changeと出ればおk
# resource "aws_instance" "test" {
#   ami           = "ami-02892a4ea9bfa2192"
#   instance_type = "t2.micro"
# }
# 管理対象外にするならterraform state rm aws_instance.test


# -----------------------------------
# Parameter Store 
# -----------------------------------
resource "aws_ssm_parameter" "host" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_HOST"
  type  = "String"
  value = aws_db_instance.mysql_standalone.address
}
resource "aws_ssm_parameter" "port" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_PORT"
  type  = "String"
  value = aws_db_instance.mysql_standalone.port
}
resource "aws_ssm_parameter" "database" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_DATABASE"
  type  = "String"
  value = aws_db_instance.mysql_standalone.name
}
resource "aws_ssm_parameter" "username" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_USERNAME"
  type  = "SecureString"
  value = aws_db_instance.mysql_standalone.username
}
resource "aws_ssm_parameter" "password" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_PASSWORD"
  type  = "SecureString"
  value = aws_db_instance.mysql_standalone.password
}


# ---------------------------------------------
# launch template
# ---------------------------------------------
resource "aws_launch_template" "app_lt" {
  update_default_version = true

  name = "${var.project}-${var.environment}-app-lt"

  image_id = data.aws_ami.app.id

  key_name = aws_key_pair.keypair.key_name

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name"  = "${var.project}-${var.environment}-app-ec2"
      Project = var.project
      Env     = var.environment
      Type    = "app"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.app_sg.id,
      aws_security_group.opmng_sg.id,
    ]
    delete_on_termination = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.app_ec2_profile.name
  }

  # デプロイ用s3からダウンロードして立ち上げていく流れ（そのための初期化スクリプト）
  user_data = filebase64("./src/initialize.sh")
}

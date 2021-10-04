# -----------------------------------
# key pair
# -----------------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.enviroment}-keypair"
  public_key = file("./src/tastylog-dev-keypair.pub")

  tags = {
    "Name"  = "${var.project}-${var.enviroment}-keypair"
    Project = var.project
    Env     = var.enviroment
  }
}

# -----------------------------------
# ec2 instance
# -----------------------------------
resource "aws_instance" "app_server" {
  # aws_amiで検索したものを指定する
  ami                         = data.aws_ami.app.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.app_sg.id,
    aws_security_group.opmng_sg.id,
  ]
  # keypairの参照名はkey_nameなので注意。詳しくはリファレンス見てね。
  key_name = aws_key_pair.keypair.key_name

  tags = {
    "Name"  = "${var.project}-${var.enviroment}-app-ec2"
    Project = var.project
    Env     = var.enviroment
    Type    = "app"
  }
}

# aws_instanceの取り込み方法 (cmd:terraform import aws_instance.test [id])
#もしtfstateをs3保存している場合にはterraform importの結果はs3へ反映される。
#ローカルでも合わせたい場合にはterraform state show hoge をして中身を確認してローカルに反映させる必要あり
#ちゃんとローカルとs3のtfstateに違いがないか確認するにはterraform planを叩いてno changeと出ればおk
# resource "aws_instance" "test" {
#   ami           = "ami-02892a4ea9bfa2192"
#   instance_type = "t2.micro"
# }
# 管理対象外にするならterraform state rm aws_instance.test

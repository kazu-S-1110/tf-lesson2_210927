# -----------------------------------
# RDS parameter group
# -----------------------------------
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.enviroment}-mysql-standalone-parametergroup"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# -----------------------------------
# option group
# -----------------------------------
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "${var.project}-${var.enviroment}-mysql-standalone-optiongroup"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# -----------------------------------
# subnet group
# -----------------------------------
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-${var.enviroment}-mysql-standalone-subnetgroup"
  # rdsが利用できるサブネットを指定する
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id,
  ]
  tags = {
    Name    = "${var.project}-${var.enviroment}-mysql-mysql_standalone_subnetgroup"
    Project = var.project
    Env     = var.enviroment
  }
}

# -----------------------------------
# RDS instance
# -----------------------------------
resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "mysql_standalone" {
  engine         = "mysql"
  engine_version = "8.0.20"

  identifier = "${var.project}-${var.enviroment}-mysql-standalone"

  username = "admin"
  # パスワードには上で作成したrandom文字列を設定
  password = random_string.db_password.result

  #storage setting
  allocated_storage     = 20
  max_allocated_storage = 30
  storage_type          = "gp2"
  storage_encrypted     = false

  #network setting
  multi_az               = false
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  name                 = "tastylog"
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name



}

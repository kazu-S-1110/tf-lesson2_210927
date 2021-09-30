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

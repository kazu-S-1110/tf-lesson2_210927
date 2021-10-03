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

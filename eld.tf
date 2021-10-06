# -----------------------------------
# ALB  (Application load balancer) (ELB: Elastic load balancer)
# -----------------------------------
resource "aws_alb" "alb" {
  name               = "${var.project}-${var.enviroment}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.web_sg.id,
  ]
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id,
  ]
}

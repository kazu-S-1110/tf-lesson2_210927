data "aws_prefix_list" "s3_pl" {
  name = "com.amazonaws.*.s3"
}

data "aws_ami" "name" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name  = "name"
    value = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name  = "root-device-type"
    value = ["ebs"]
  }
  filter {
    name  = "virtualization-type"
    value = ["hvm"]
  }
}

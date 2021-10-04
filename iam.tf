data "aws_iam_policy_document" "ec2_assume_role" {
  #自動で作成されるものを明示的に定義するのでおまじないだと思えばおけ。
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

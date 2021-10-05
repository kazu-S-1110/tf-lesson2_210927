# countを利用して指定回数処理を繰り返す方法
# resource "aws_iam_user" "user" {
#   count = 5
#   name  = "test-user-${count.index + 1}"
# }

# for-eachを使用してobjectライクに扱う方法
# resource "aws_vpc" "test-vpc" {
#   cidr_block = "192.168.0.0/20"
# }
# resource "aws_subnet" "test-subnet" {
#   for_each = {
#     "192.168.1.0/24" = "ap-northeast-1a"
#     "192.168.2.0/24" = "ap-northeast-1c"
#     "192.168.3.0/24" = "ap-northeast-1d"
#   }

#   vpc_id            = aws_vpc.test-vpc.id
#   cidr_block        = each.key
#   availability_zone = each.value
# }

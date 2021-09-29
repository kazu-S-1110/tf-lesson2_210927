resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.enviroment}-vpc"
    Project = var.project
    Env     = var.enviroment
  }
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true //中に作成するEC2に自動でpublic ipを付与する

  tags = {
    "Name"  = "${var.project}-${var.enviroment}-public_subnet_1a"
    Project = var.project
    Env     = var.enviroment
    Type    = "public"
  }
}
resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true //中に作成するEC2に自動でpublic ipを付与する

  tags = {
    "Name"  = "${var.project}-${var.enviroment}-public_subnet_1c"
    Project = var.project
    Env     = var.enviroment
    Type    = "public"
  }
}
resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = false //中に作成するEC2に自動でpublic ipを付与する

  tags = {
    "Name"  = "${var.project}-${var.enviroment}-private_subnet_1a"
    Project = var.project
    Env     = var.enviroment
    Type    = "private"
  }
}
resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = false //中に作成するEC2に自動でpublic ipを付与する

  tags = {
    "Name"  = "${var.project}-${var.enviroment}-private_subnet_1c"
    Project = var.project
    Env     = var.enviroment
    Type    = "private"
  }
}

# -----------------------------------
# Route table
# -----------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"  = "${var.project}-${var.enviroment}-public_rt"
    Project = var.project
    Env     = var.enviroment
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}
resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"  = "${var.project}-${var.enviroment}-private_rt"
    Project = var.project
    Env     = var.enviroment
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}
resource "aws_route_table_association" "private_rt_1c" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}

terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  backend "s3" {
    bucket  = "tastylog-tfstate-bucket-kaz-211003"
    key     = "tastylog-dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform-test_210927"
  }
}

provider "aws" {
  profile = "terraform-test_210927"
  region  = "ap-northeast-1"
}

provider "aws" {
  alias   = "virginia"
  profile = "terraform"
  region  = "us-east-1"
}

variable "project" {
  type = string
}
variable "environment" {
  type = string
}

variable "domain" {
  type = string
}


# ---------------------------------------------
# module demo
# ---------------------------------------------
module "webserver" {
  source        = "./modules/nginx_server"
  instance_type = "t2.micro"
}

output "web_server_id" {
  value = module.webserver.instance_id
  # Outputs:
  # web_server_id = "i-07b8e845414db7105"
}

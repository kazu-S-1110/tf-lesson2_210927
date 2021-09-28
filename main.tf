terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  profile = "terraform-test_210927"
  region  = "ap-northeast-1"
}

variable "project" {
  type = string
}
variable "enviroment" {
  type = string
}

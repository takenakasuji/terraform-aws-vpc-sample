# variables.tf

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
    default = "ap-northeast-1"
}

variable "vpc" {
  default = {
      name = "okb-api-vpc"
      cidr = "10.0.0.0/8"
  }
}

variable "igw_name" {
  default = "okb-api-igw"
}

variable "availability_zones" {
    default = {
        ap-northeast-1a = "ap-northeast-1a"
        ap-northeast-1c = "ap-northeast-1c"
    }
}

variable "public_subnet_1a" {
  default = {
    ip = "10.0.0.0/24"
    name = "public_subnet_1a"
  }
}

variable "public_subnet_1c" {
  default = {
    ip = "10.0.1.0/24"
    name = "public_subnet_1c"
  }
}

variable "private_subnet_1a" {
  default = {
    ip = "10.0.2.0/24"
    name = "public_subnet_1c"
  }
}

variable "private_subnet_1c" {
  default = {
    ip = "10.0.3.0/24"
    name = "public_subnet_1c"
  }
}

variable "prod_pub_route" {
  default = {
    cidr_block "0.0.0.0/0"
  }
}

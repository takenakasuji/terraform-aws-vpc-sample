# main.tf

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.region}"
}

resource "aws_vpc" "OKB-API-VPC" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "false"
  tags {
    Name = "OKB-API-VPC"
  }
}

resource "aws_internet_gateway" "OKB-API-IGW" {
    vpc_id = "${aws_vpc.OKB-API-VPC.id}"
}

resource "aws_subnet" "Public-Subnet-1a" {
    vpc_id = "${aws_vpc.OKB-API-VPC.id}"
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-northeast-1a"
    tags {
      Name = "Public-Subnet-1a"
    }
}

resource "aws_subnet" "Public-Subnet-1c" {
    vpc_id = "${aws_vpc.OKB-API-VPC.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-1c"
    tags {
      Name = "Public-Subnet-1c"
    }
}

resource "aws_subnet" "Private-Subnet-1a" {
    vpc_id = "${aws_vpc.OKB-API-VPC.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-northeast-1a"
    tags {
      Name = "Private-Subnet-1a"
    }
}

resource "aws_subnet" "Private-Subnet-1c" {
    vpc_id = "${aws_vpc.OKB-API-VPC.id}"
    cidr_block = "10.0.3.0/24"
    availability_zone = "ap-northeast-1c"
    tags {
      Name = "Private-Subnet-1c"
    }
}

resource "aws_route_table" "Public-Route" {
    vpc_id = "${aws_vpc.OKB-API-VPC.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.OKB-API-IGW.id}"
    }
}

resource "aws_route_table" "Private-Route" {
    vpc_id = "${aws_vpc.OKB-API-VPC.id}"
}

resource "aws_route_table_association" "Public-Subnet-1a" {
    subnet_id = "${aws_subnet.Public-Subnet-1a.id}"
    route_table_id = "${aws_route_table.Public-Route.id}"
}

resource "aws_route_table_association" "Public-Subnet-1c" {
    subnet_id = "${aws_subnet.Public-Subnet-1c.id}"
    route_table_id = "${aws_route_table.Public-Route.id}"
}

resource "aws_route_table_association" "Private-Subnet-1a" {
    subnet_id = "${aws_subnet.Private-Subnet-1a.id}"
    route_table_id = "${aws_route_table.Private-Route.id}"
}

resource "aws_route_table_association" "Private-Subnet-1c" {
    subnet_id = "${aws_subnet.Private-Subnet-1c.id}"
    route_table_id = "${aws_route_table.Private-Route.id}"
}

resource "aws_security_group" "ssh" {
    name = "ssh"
    description = "Allow SSH inbound traffic"
    vpc_id = "${aws_vpc.OKB-API-VPC.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

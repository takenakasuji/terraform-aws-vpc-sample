# main.tf

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc.cidr}"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "false"
  tags {
    Name = "${var.vpc.name}"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
      Name = "${var.igw_name}"
    }
}

resource "aws_subnet" "public_subnet_1a" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public_subnet_1a.ip}"
    availability_zone = "ap-northeast-1a"
    tags {
      Name = "${var.public_subnet_1a.name}"
    }
}

resource "aws_subnet" "public_sunbnet_1c" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public_subnet_1c.ip}"
    availability_zone = "ap-northeast-1c"
    tags {
      Name = "Public-Subnet-1c"
    }
}

resource "aws_subnet" "private_subnet_1a" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.private_subnet_1a.ip}"
    availability_zone = "ap-northeast-1a"
    tags {
      Name = "${var.private_subnet_1a.name}"
    }
}

resource "aws_subnet" "private_subnet_1c" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.private_subnet_1c.ip}"
    availability_zone = "ap-northeast-1c"
    tags {
      Name = "${var.private_subnet_1c.name}"
    }
}

resource "aws_route_table" "prod_pub_route" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "${var.prod_pub_route.cidr_block}"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}

resource "aws_route_table" "prod_prv_ruoute" {
    vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table_association" "Public-Subnet-1a" {
    subnet_id = "${aws_subnet.public_subnet_1a.id}"
    route_table_id = "${aws_route_table.prod_pub_route.id}"
}

resource "aws_route_table_association" "Public-Subnet-1c" {
    subnet_id = "${aws_subnet.public_sunbnet_1c.id}"
    route_table_id = "${aws_route_table.prod_pub_route.id}"
}

resource "aws_route_table_association" "Private-Subnet-1a" {
    subnet_id = "${aws_subnet.private_subnet_1a.id}"
    route_table_id = "${aws_route_table.prod_prv_ruoute.id}"
}

resource "aws_route_table_association" "Private-Subnet-1c" {
    subnet_id = "${aws_subnet.private_subnet_1c.id}"
    route_table_id = "${aws_route_table.prod_prv_ruoute.id}"
}

resource "aws_security_group" "ssh" {
    name = "ssh"
    description = "Allow SSH inbound traffic"
    vpc_id = "${aws_vpc.vpc.id}"
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

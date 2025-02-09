provider "aws" {
    region     = "ap-south-1"
// add keys here
}

resource "aws_vpc" "vpc1" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "vpc1"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc1.id

    tags = {
        Name = "internet_gateway"
    }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.vpc1.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "route_table"
    }
}

resource "aws_route_table_association" "rta" {
    subnet_id      = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rt.id
}

resource "aws_subnet" "subnet1" {
    vpc_id            = aws_vpc.vpc1.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-south-1a"

    tags = {
        Name = "subnet1"
    }
}

resource "aws_security_group" "allow_ssh" {
    vpc_id = aws_vpc.vpc1.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_ssh"
    }
}

resource "aws_instance" "instance1" {
    ami           = "ami-00bb6a80f01f03502"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.subnet1.id
    count = 2
    //security_groups = [aws_security_group.allow_ssh.name]
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    tags = {
        Name = "instance2"
    }
}
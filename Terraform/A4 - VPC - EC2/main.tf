# Configuring provider
provider "aws" {
    region = "us-east-2"

}

# Creating a VPC
resource "aws_vpc" "test-vpc" {
    cidr_block = "10.0.0.0/16"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "test-ig" {
    vpc_id = aws_vpc.test-vpc.id
    tags = {
        Name = "gateway1"
    }
}

# Setting up the route table
resource "aws_route_table" "test-rt" {
    vpc_id = aws_vpc.test-vpc.id
    route {
        # pointing to the internet
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test-ig.id
    }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.test-ig.id
    }
    tags = {
        Name = "rt1"
    }
}

# Setting up the subnet
resource "aws_subnet" "test-subnet" {
    vpc_id = aws_vpc.test-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-2b"
    tags = {
        Name = "subnet1"
    }
}

# Associating the subnet with the route table
resource "aws_route_table_association" "test-rt-sub-assoc" {
    subnet_id = aws_subnet.test-subnet.id
    route_table_id = aws_route_table.test-rt.id
}



# Creating an Ubuntu EC2 instance
resource "aws_instance" "test-instance" {
    ami = "ami-09040d770ffe2224f"
    instance_type = "t2.micro"
    vpc_id = aws_vpc.test-vpc.id

    tags = {
        Name = "Assignment4-instance"
    }
}   
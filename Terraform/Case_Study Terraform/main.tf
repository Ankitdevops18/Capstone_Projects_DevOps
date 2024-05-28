provider "aws" {
  region = "us-east-1"  # N. Virginia
}

# VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-igw"
  }
}

# Subnet 1
resource "aws_subnet" "example_subnet1" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "example-subnet1"
  }
}

# Subnet 2
resource "aws_subnet" "example_subnet2" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "example-subnet2"
  }
}

# Route Table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "example-route-table"
  }
}

# Route Table Association for Subnet 1
resource "aws_route_table_association" "example_rta1" {
  subnet_id      = aws_subnet.example_subnet1.id
  route_table_id = aws_route_table.example_route_table.id
}

# Route Table Association for Subnet 2
resource "aws_route_table_association" "example_rta2" {
  subnet_id      = aws_subnet.example_subnet2.id
  route_table_id = aws_route_table.example_route_table.id
}

# Security Group
resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "example-sg"
  }
}

# Creating a new network interface
resource "aws_network_interface" "ni-subnet1" {
    subnet_id = aws_subnet.example_subnet1.id
    private_ips = ["10.0.1.10"]
    security_groups = [aws_security_group.example_sg.name]
}

# Creating a new network interface
resource "aws_network_interface" "ni-subnet2" {
    subnet_id = aws_subnet.example_subnet2.id
    private_ips = ["10.0.2.10"]
    security_groups = [aws_security_group.example_sg.name]
}

# EC2 Instance in Subnet 1
resource "aws_instance" "example_instance1" {
  ami           = "ami-04b70fa74e45c3917"  # Replace with a valid Ubuntu AMI ID
  instance_type = "t2.micro"
  network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.ni-subnet1.id
    }
  security_groups = [aws_security_group.example_sg.name]

  user_data = file("install_apache.sh")  # Run the Apache installation script

  tags = {
    Name = "example-instance1"
  }
}

# EC2 Instance in Subnet 2
resource "aws_instance" "example_instance2" {
  ami           = "ami-04b70fa74e45c3917"  # Replace with a valid Ubuntu AMI ID
  instance_type = "t2.micro"
  network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.ni-subnet2.id
    }
  security_groups = [aws_security_group.example_sg.name]

  user_data = file("install_apache.sh")  # Run the Apache installation script

  tags = {
    Name = "example-instance2"
  }
}

output "instance1_public_ip" {
  value = aws_instance.example_instance1.public_ip
}

output "instance2_public_ip" {
  value = aws_instance.example_instance2.public_ip
}
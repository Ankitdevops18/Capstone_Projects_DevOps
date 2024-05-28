provider "aws" {
  region = "us-east-1"  # N. Virginia
}


# EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-04b70fa74e45c3917"  # Replace with a valid AMI ID
  instance_type = "t2.micro"

  user_data = file("install_apache.sh")  # Run the Apache installation script

  tags = {
    Name = "Assignment5-instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
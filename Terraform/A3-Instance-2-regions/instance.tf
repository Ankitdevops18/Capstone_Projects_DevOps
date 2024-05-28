
# EC2 Instance in Ohio
resource "aws_instance" "ohio_instance" {
  provider      = aws.ohio
  ami           = "ami-09040d770ffe2224f"  # Replace with a valid AMI ID for Ohio
  instance_type = "t2.micro"

  tags = {
    Name = "hello-ohio"
  }
}

# EC2 Instance in Virginia
resource "aws_instance" "virginia_instance" {
  provider      = aws.virginia
  ami           = "ami-04b70fa74e45c3917"  # Replace with a valid AMI ID for Virginia
  instance_type = "t2.micro"

  tags = {
    Name = "hello-virginia"
  }
}

output "ohio_instance_id" {
  value = aws_instance.ohio_instance.id
}

output "virginia_instance_id" {
  value = aws_instance.virginia_instance.id
}
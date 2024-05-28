# Create an EC2 instance in the public subnet
resource "aws_instance" "worker_node" {
  count         = 1
  ami           = var.ami
  instance_type = "t2.medium"


  tags = {
    Name = "Assignment1-Instance"
  }
}

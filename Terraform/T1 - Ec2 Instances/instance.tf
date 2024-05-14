# Create an EC2 instance in the public subnet
resource "aws_instance" "worker_node" {
  count         = 3
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.medium"


  tags = {
    Name = "Worker-Node-${count.index}"
  }
}



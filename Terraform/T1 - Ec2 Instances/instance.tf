# Create an EC2 instance in the public subnet
resource "aws_instance" "worker_node" {
  count         = 3
  ami           = "ami-04b70fa74e45c3917" 
  instance_type = "t2.medium"  
  security_groups = ["sg-0cbc52801035b93ec"]
  vpc = "vpc-0b57dda94f28d36b3"


  tags = {
    Name = "Worker-Node-${count.index}"
  }
}





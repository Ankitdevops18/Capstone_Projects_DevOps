# Create an EC2 instance in the public subnet
resource "aws_instance" "worker_node" {
  count         = 3
  ami           = var.ami 
  instance_type = "t2.medium"  
  security_groups = var.sg-id


  tags = {
    Name = "Worker-Node-${count.index}"
  }
}





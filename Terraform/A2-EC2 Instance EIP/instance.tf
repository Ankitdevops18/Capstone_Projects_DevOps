# Create an EC2 instance in the public subnet
resource "aws_instance" "asignmnt2-inst" {
  count         = 1
  ami           = var.ami
  instance_type = "t2.micro"


  tags = {
    Name = "Assignment2-Instance"
  }
}

resource "aws_eip" "a2_eip" {
  instance         = aws_instance.asignmnt2-inst

  tags = {
    Name = "Assignment2-EIP"
  }
}


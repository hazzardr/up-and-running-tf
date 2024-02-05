provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "tf_example" {
  ami = "ami-0fb653ca2d3203ac1" # Ubuntu 20.04
  instance_type = "t2.micro"

  tags = {
    Name = "tf-example"
  }
}
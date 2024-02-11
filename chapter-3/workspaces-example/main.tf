
# We use partial configuration which will be passed in via `backend.hcl` to `tf init`
# e.g.: 
# $ terraform init -backend-config=../backend.hcl
#
# However, Key has to be unique so we don't parameterize it
terraform {
  backend "s3" {
    key = "workspaces-example/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "ec2_example" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type = terraform.workspace == "default" ? "t2.medium" : "t2.micro"
}
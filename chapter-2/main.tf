provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "hazzardr-terraform-up-and-running-state"

  # so we don't accidentally delete remote state with a destroy command
  lifecycle {
    prevent_destroy = true
  }
}
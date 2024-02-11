variable "state_bucket_name" {
  description = "the name of the s3 bucket which hosts the backend state"
  type = string
  default = "hazzardr-terraform-up-and-running-state"
}
variable "state_lock_table_name" {
  description = "the name of the dynamodb table that tracks locks on backen state"
  type = string
  default = "terraform-up-and-running-locks"
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "the ARN of the state s3 bucket"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "the name of the table managing the locks on the backend state"
  
}

# We use partial configuration which will be passed in via `backend.hcl` to `tf init`
# e.g.: 
# $ terraform init -backend-config=../backend.hcl
#
# However, Key has to be unique so we don't parameterize it
terraform {
  backend "s3" {
    key = "remote-backend/global/s3/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name

  # so we don't accidentally delete remote state with a destroy command
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Not technically necessary since buckets are private by default. But, this stops us
# from accidentally making it public later (will have pw etc in it)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = var.state_lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
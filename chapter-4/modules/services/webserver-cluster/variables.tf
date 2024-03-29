variable "cluster_name" {
  description = "The name to use for all cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the DB's remote state"
  type = string
}

variable "db_remote_state_key" {
  description = "The path for the db's remote state in s3"
  type = string
}

variable "instance_type" {
  description = "The type of EC2 Instance to run"
  type = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type = number
}
variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type = number
}
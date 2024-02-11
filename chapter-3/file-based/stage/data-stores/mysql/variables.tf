variable "db_username" {
  description = "The username for the mysql db"
  type = string
  sensitive = true
}

variable "db_pass" {
  description = "The password for the mysql db"
  type = string
  sensitive = true
}
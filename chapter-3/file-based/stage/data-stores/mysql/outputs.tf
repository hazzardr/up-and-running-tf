output "address" {
  value = aws_db_instance.example.address
  description = "Connect to the database at this address"
}

output "port" {
  value = aws_db_instance.example.port
  description = "Connect to the database at this port"
}
output "asg_name" {
  value = aws_autoscaling_group.example.name
  description = "Name of the ASG"
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "The DNS name of the ALB we can interact with"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
  description = "The ID of the security group on the load balancer"
}
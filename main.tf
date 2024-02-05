variable "server_port" {
    description = "The port serving HTTP Traffic"
    type = number
    default = 8080
}

data "aws_vpc" "default" {
    default = true
}
data "aws_subnets" "default"{
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}
output "public_ip" {
    value = aws_instance.tf_example.public_ip
    description = "The public IP Address of the webserver"
  
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "instance" {
    name = "tf-example-instance"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_launch_configuration" "tf_example" {
    image_id = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.id]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.xhtml
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
    
    # Required when using a launch config w/ asg 
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "tf_example" {
    launch_configuration = aws_launch_configuration.tf_example.name
    vpc_zone_identifier = data.aws_subnets.default.ids

    min_size = 2
    max_size = 10

    tag {
        key = "Name"
        value = "tf-asg-example"
        propagate_at_launch = true
    }
  
}

resource "aws_lb" "tf_example" {
    name = "tf-asg-example-lb"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.tf_example.arn
    port = 80
    protocol = "HTTP"
  
    default_action {
      type = "fixed_response"

      fixed_response {
        content_type = "text/plain"
        message_body = "404: page not found (test)"
        status_code = 404
      }
    }
}

resource "aws_security_group" "alb" {
    name = "tf-example-alb"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
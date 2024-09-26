// Output the public IP addresses of EC2 instances
output "instance_public_ips" {
  description = "The public IP address of the EC2 instances."
  value = [for instance in aws_instance.web : instance.public_ip]
}


// output DNS of load balancer 
output "lb_dns" {
  description = "The DNS of the application load balancer"
  value = aws_lb.alb.dns_name
}


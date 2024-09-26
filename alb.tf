// create load balancer
resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id] 
}

// create lb target group 
resource "aws_lb_target_group" "target_alb" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/health"
    port = 80
    protocol = "HTTP"
  }
}

// Create lb target group attachment
resource "aws_lb_target_group_attachment" "alb_tga" {
  count = length(var.instance_names)
  target_group_arn = aws_lb_target_group.target_alb.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
  depends_on = [aws_lb_target_group.target_alb]
}

// create listener 
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_alb.arn
  }
}

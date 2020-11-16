resource "aws_lb_target_group" "foundry_lb_tg" {
  name     = "foundry-lb-tg"
  port     = 30000
  protocol = "gRPC"
  vpc_id   = aws_default_vpc.default.id
  health_check {
      port = 30000
      path = "/css/style.css"
  }
}

resource "aws_lb" "foundry_loadbalancer" {
  name               = "foundry-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.foundry_loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.foundry_lb_tg.arn
  }
}
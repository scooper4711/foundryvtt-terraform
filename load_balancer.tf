resource "aws_lb_target_group" "foundry_lb_tg" {
  name     = "foundry_lb_tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
}
resource "aws_lb" "foundry_loadbalancer" {
  name               = "foundry_loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}
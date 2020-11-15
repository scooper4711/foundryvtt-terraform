resource "aws_lb" "foundry-loadbalancer" {
  name               = "foundry-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_foundry.id]
  subnets            = [aws_default_subnet.default_az1.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}
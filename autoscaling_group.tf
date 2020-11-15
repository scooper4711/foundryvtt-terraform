
resource "aws_autoscaling_group" "foundryvtt_autoscaling_group" {
  name               = "foundryvtt_autoscaling_group"
  availability_zones = ["us-west-2a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]
  launch_template {
    id      = aws_launch_template.foundryvtt_launchtemplate.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "foundryvtt_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.foundryvtt_autoscaling_group.id
  elb                    = aws_lb.foundry_loadbalancer.id
}
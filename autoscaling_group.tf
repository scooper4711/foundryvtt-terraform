
resource "aws_autoscaling_group" "foundryvtt_autoscaling_group" {
  availability_zones = ["us-west-2a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.foundryvtt_launchtemplate.id
    version = "$Latest"
  }
}
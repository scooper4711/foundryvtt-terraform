resource "aws_launch_template" "foundryvtt_launchtemplate" {
  name_prefix   = "foundryvtt-launchtemplate"
  image_id      = "ami-0ab0f3d693776534b"
  instance_type = "t2.micro"
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Foundry VTT"
    }
  }
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_foundry.id, aws_security_group.ssh_from_home.id, aws_security_group.allow_load_balancer.id]
  user_data = filebase64("${path.module}/startup.sh")
}

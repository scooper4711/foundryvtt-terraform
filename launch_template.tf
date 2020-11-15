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

  user_data = "sudo yum update true;node $HOME/foundryvtt/resources/app/main.js --dataPath=$HOME/foundrydata --nopnp --hostname=inharnsway.com"
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = var.availability_zone

  tags = {
    Name = "Default subnet for us-west-2a"
  }
}
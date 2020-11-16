
data "aws_ami" "foundry-ami" {
  most_recent      = true
  owners           = ["063843753876"]
  filter {
    name   = "name"
    values = ["foundryvtt*"]
  }
}

resource "aws_instance" "foundry" {
  # us-west-2
  ami           = aws_ami.foundry-ami.id
  instance_type = "t2.micro"
  user_data     = filebase64("${path.module}/startup.sh")
  subnet_id  = aws_default_subnet.default_az1.id
}
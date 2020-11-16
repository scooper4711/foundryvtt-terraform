
data "aws_ami" "foundry_ami" {
  most_recent      = true
  owners           = [var.ami_owner]
  filter {
    name   = "name"
    values = ["foundryvtt*"]
  }
}

resource "aws_instance" "foundry" {
  ami             = data.aws_ami.foundry_ami.id
  instance_type   = var.instance_size
  user_data       = filebase64("${path.module}/startup.sh")
  subnet_id       = aws_default_subnet.default_az1.id
  security_groups = [aws_security_group.allow_http.id,aws_security_group.ssh_from_home.id]
}
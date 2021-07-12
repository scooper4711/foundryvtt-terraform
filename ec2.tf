resource "aws_eip" "foundry" {
  instance = aws_instance.foundry.id
  vpc      = true
}

data "aws_ami" "foundry_ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["foundryvtt*"]
  }
}


data "aws_ebs_volume" "foundrydata" {
  most_recent = true
  filter {
    name   = "tag:Name"
    values = [var.ebs_name]
  }
}
resource "aws_instance" "foundry" {
  ami                    = data.aws_ami.foundry_ami.id
  instance_type          = var.instance_size
  user_data              = templatefile("${path.module}/startup.sh", { name = var.name, domain = var.domain })
  subnet_id              = aws_default_subnet.default_az1.id
  iam_instance_profile   = aws_iam_instance_profile.foundry_profile.id
  key_name               = aws_key_pair.login.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.ssh_from_home.id]
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/sdb"
  volume_id   = data.aws_ebs_volume.foundrydata.id
  instance_id = aws_instance.foundry.id
}

resource "aws_iam_instance_profile" "foundry_profile" {
  name = "foundry_profile"
  role = aws_iam_role.foundry_role.name
}

resource "aws_key_pair" "login" {
  key_name   = "login"
  public_key = var.public_key
}
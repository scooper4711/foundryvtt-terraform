resource "aws_eip" "foundry" {
  for_each = var.ec2_instances
  instance = aws_instance.each.value.id
  vpc      = true
}
data "aws_ami" "foundry_ami" {
  most_recent      = true
  owners           = [var.ami_owner]
  filter {
    name   = "name"
    values = list(var.ami_wildcard)
  }
}

data "aws_ebs_snapshot" "latest_snapshot" {
  for_each    = var.ec2_instances
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "volume-size"
    values = [each.value.ebs_size]
  }

  filter {
    name   = "tag:Name"
    values = [each.value.ebs_name]
  }
}

resource "aws_ebs_volume" "foundrydata" {
  for_each          = var.ec2_instances
  availability_zone = aws_default_subnet.default_az1.availability_zone
  size              = each.value.ebs_size

  tags = {
    Name     = each.value.ebs_name
    Function = "fvtt_data"
  }
}
resource "aws_instance" "foundry" {
  for_each             = var.ec2_instances
  ami                  = data.aws_ami.foundry_ami.id
  instance_type        = var.instance_size
  user_data            = templatefile("${path.module}/startup.sh",{domain=var.domain, foundry_download=var.foundry_download})
  subnet_id            = aws_default_subnet.default_az1.id
  iam_instance_profile = aws_iam_instance_profile.foundry_profile.id
  key_name             = aws_key_pair.login.key_name
  vpc_security_group_ids      = [aws_security_group.allow_http.id,aws_security_group.ssh_from_home.id]
}

resource "aws_volume_attachment" "ebs_attachment" {
  for_each    = var.ec2_instances
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.foundrydata.each.key.id
  instance_id = aws_instance.foundry.each.key.id
}

resource "aws_iam_instance_profile" "foundry_profile" {
  name = "foundry_profile"
  role = aws_iam_role.foundry_role.name
}

resource "aws_key_pair" "login" {
  key_name   = "login"
  public_key = var.public_key
}
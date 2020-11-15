resource "aws_security_group" "allow_foundry" {
  name        = "allow_foundry"
  description = "Allow Foundry inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "Foundry from VPC"
    from_port   = 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_foundry"
  }
}

resource "aws_security_group" "ssh_from_home" {
  name        = "ssh_from_home"
  description = "Allow ssh inbound traffic from home"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH from home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.218.118.143/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_from_home"
  }
}
variable "home_cidr" {
  type        = string
  description = "The CIDR address (/32) to allow SSH for"
}

variable "ami_owner" {
  type        = string
  description = "The owner id of the AMI for Foundry. This is found in the EC2->AMIs section of the AWS console."
  default     = "137112412989"
}

variable "ami_wildcard" {
  type        = string
  description = "The pattern to match for the ec2 AMI. Will always take the most recent. Created with packer"
  default     = "foundryvtt*"
}

variable "instance_size" {
  type        = string
  default     = "t3a.micro"
  description = "The size of the instance to run"
}

variable "domain" {
  type        = string
  description = "The domain name you want for your VTT. You must control this domain"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "The region you want to deploy to, e.g. us-west-2"
}
variable "availability_zone" {
  type        = string
  default     = "us-west-2a"
  description = "The az of the region you want to deploy to, e.g. us-west-2a"
}

variable "public_key" {
  type        = string
  description = "the public half of the key pair to allow you to ssh in."
}

variable "name" {
  type = string
  description = "The domain name for your instance, e.g. www"
  default = "www"
}

variable "ebs_name" {
  type = string
  description = "The name tag which identifies the ebs volume to mount as /home/ec2-user/foundrydata"
  default = "Foundry Data"
}
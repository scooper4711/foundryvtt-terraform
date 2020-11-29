variable "home_cidr" {
    type        = string
    description = "The CIDR address (/32) to allow SSH for"
}

variable "ami_owner" {
    type        = string
    description = "The owner id of the AMI for Foundry. If you want to start from scratch, use 137112412989. After that, use the id of the user that makes your AMI image."
}

variable "ami_wildcard" {
    type        = string
    description = "the pattern to match for the ec2 AMI. Will always take the most recent. If you want to start from scratch, use amzn2-ami-hvm-2.0.20201126.0-x86_64-gp2"
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
    type         = string
    default      = "us-west-2"
    description  = "The region you want to deploy to, e.g. us-west-2"
}
variable "availability_zone" {
    type         = string
    default      = "us-west-2a"
    description  = "The az of the region you want to deploy to, e.g. us-west-2a"
}

variable "foundry_download" {
    type        = string
    default     = ""
    description = "The URL to download FoundryVTT software from. Valid for only 5 minutes. Omit if your AMI already has FoundryVTT software"
}
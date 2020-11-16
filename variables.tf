variable "home_cidr" {
    type        = string
    description = "The CIDR address (/32) to allow SSH for"
}

variable "ami_owner" {
    type        = string
    description = "The owner id of the AMI for Foundry"
}

variable "instance_size" {
    type        = string
    description = "The size of the instance to run"
}

variable "domain" {
    type        = string
    description = "The domain name you want for your VTT"
}
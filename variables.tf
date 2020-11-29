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
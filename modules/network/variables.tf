variable "platform_name" {}

variable "platform_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  type = "list"
  default = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
}

variable "public_subnet_cidrs" {
  type = "list"
  default = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
}

data "aws_availability_zones" "available" {}

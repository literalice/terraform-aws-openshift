variable "platform_name" {}

variable "platform_cidr" {
  default = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {}

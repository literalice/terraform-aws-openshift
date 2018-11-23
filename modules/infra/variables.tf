variable "platform_name" {}

variable "platform_vpc_id" {}

variable "public_subnet_ids" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "operator_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "use_spot" {
  default = false
}

variable "use_community" {
  default = false
}

variable "master_count" {
  default = 1
}

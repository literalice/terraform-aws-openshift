variable "platform_vpc_id" {}

variable "platform_name" {}

variable "platform_domain" {
  default = ""
}

variable "master_endpoints" {
  type    = "list"
  default = []
}

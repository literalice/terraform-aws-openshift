variable "platform_vpc_id" {}

variable "platform_name" {}

variable "platform_domain" {
  default = ""
}

variable "platform_domain_administrator_email" {
  default = ""
}

variable "bastion_endpoint" {}
variable "bastion_ssh_user" {}
variable "bastion_private_key" {}

variable "master_endpoints" {
  type    = "list"
  default = []
}

variable "router_endpoints" {
  type    = "list"
  default = []
}

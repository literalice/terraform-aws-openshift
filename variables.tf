variable "platform_name" {
  description = "The name of the cluster that is used for tagging some resources"
}

variable "operator_cidrs" {
  type        = "list"
  default     = ["0.0.0.0/0"]
  description = "CIDRS that is allowed from which master api can be accessed"
}

variable "public_cidrs" {
  type        = "list"
  default     = ["0.0.0.0/0"]
  description = "CIDRS that is allowed from which public users can access served services in the cluster"
}

variable "use_spot" {
  default = false
}

variable "master_count" {
  default = 1
}

variable "compute_node_count" {
  default = 3
}

variable "master_instance_type" {
  default = "m4.xlarge"
}

variable "compute_node_instance_type" {
  default = "m4.large"
}

variable "use_community" {
  description = "Sets true if you want to install OKD."
  default     = false
}

variable "rh_subscription_pool_id" {
  description = "Red Hat subscription pool id for OpenShift Container Platform"
  default     = ""
}

variable "rhn_username" {
  description = "Red Hat Network login username for registration system of the OpenShift Container Platform cluster"
  default     = ""
}

variable "rhn_password" {
  description = "Red Hat Network login password for registration system of the OpenShift Container Platform cluster"
  default     = ""
}

# Domains

variable "platform_domain" {
  description = "Public DNS subdomain for access to services served in the cluster"
  default     = ""
}

variable "platform_domain_administrator_email" {
  default = ""
}

variable "identity_providers" {
    type        = "list"
    description = "The identity providers to enable (AllowAllIdentityProvider, GoogleIdentityProvider)"
    default     = [
        "AllowAllIdentityProvider"
    ]
}

variable "google_client_id" {
    type        = "string"
    description = "The Google client id used by the GoogleIdentityProvider"
    default     = ""
}

variable "google_client_secret" {
    type        = "string"
    description = "The client secret used by the GoogleIdentityProvider"
    default     = ""
}

variable "google_client_domain" {
    type        = "string"
    description = "The domain used by the GoogleIdentityProvider"
    default     = ""
}

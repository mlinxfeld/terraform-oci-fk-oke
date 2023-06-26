variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}

variable "kubernetes_version" {
  default = "v1.26.2"
}

variable "node_pool_size" {
  default = 3
}

variable "min_number_of_nodes" {
  default = 3
}

variable "max_number_of_nodes" {
  default = 10
}


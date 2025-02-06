variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "ocir_user_name" {}
variable "ocir_user_password" {}

variable "number_of_nginx_replicas" {
   default = 10
}

variable "oke_node_shape" {
  default = "VM.Standard.A1.Flex"
}

variable "oke_node_shape_memory" {
  default = 4
}

variable "oke_node_shape_ocpus" {
  default = 1
}

variable "lb_shape" {
  default = "flexible"
}

variable "flex_lb_min_shape" {
  default = 10
}

variable "flex_lb_max_shape" {
  default = 100
}

variable "use_reserved_public_ip_for_lb" {
  default = true
}

variable "lb_listener_port" {
  default = 80
}

variable "lb_nsg" {
  default = true
}

variable "network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR                        = "10.20.0.0/16"
    NODES-PODS-SUBNET-REGIONAL-CIDR = "10.20.30.0/24"
    LB-SUBNET-REGIONAL-CIDR         = "10.20.20.0/24"
    ENDPOINT-SUBNET-REGIONAL-CIDR   = "10.20.10.0/28"
    ALL-CIDR                        = "0.0.0.0/0"
  }
}

variable "ocir_namespace" {
  default = ""
}

variable "ocir_repo_name" {
  default = "fknginx"
}

variable "ocir_docker_repository" {
  default = ""
}

variable "ocir_user_email" {
  default = "martin.linxfeld@foggykitchen.com"
}

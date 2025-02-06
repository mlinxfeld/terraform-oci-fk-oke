variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}

variable "availablity_domain_name" {
  default = ""
}

variable "number_of_nginx_replicas" {
   default = 10
}

variable "oke_node_shape" {
  default = "VM.Standard.A1.Flex"
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

variable "pvc_from_existing_block_volume" { 
  description = "Existing (true) means created by Terraform, in opposite (false) it will be create from with K8S."
  default = true
}

variable "block_volume_name" {
  default = "fkblockvolume"
}

variable "block_volume_size" {
  default = 50
}

variable "fs_type" {
  default = "ext4"
#  default = "ext3"  
#  default = "xfs"
}

variable "vpus_per_gb" {
  default = "0" # Lower Cost 
#  default = "10" # Balanced
#  default = "20" # Higher Performance
#  default = "30" # Ultra High Performance 
}



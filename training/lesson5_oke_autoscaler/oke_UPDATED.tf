module "fk-oke" {
  providers                      = { oci = oci.targetregion }
  source                         = "github.com/mlinxfeld/terraform-oci-fk-oke"
  tenancy_ocid                   = var.tenancy_ocid
  region                         = var.region 
  compartment_ocid               = var.compartment_ocid
  cluster_type                   = "enhanced"
  k8s_version                    = var.kubernetes_version
  node_pool_count                = 1
  node_count                     = var.node_pool_size
  node_linux_version             = var.node_linux_version
  oci_vcn_ip_native              = true
  use_existing_vcn               = false
  is_api_endpoint_subnet_public  = true # OKE API Endpoint will be public (Internet facing)
  is_lb_subnet_public            = true # OKE LoadBalanacer will be public (Internet facing)
  is_nodepool_subnet_public      = false # OKE NodePool will be private (not Internet facing)
  autoscaler_enabled             = var.enable_autoscaler_addon # Enabling Autoscaler as OKE Add-On
  autoscaler_min_number_of_nodes = var.min_number_of_nodes # Autoscaler minimum number of nodes
  autoscaler_max_number_of_nodes = var.max_number_of_nodes # Autoscaler maximum number of nodes
}


module "fk-oke" {
  source                        = "github.com/mlinxfeld/terraform-oci-fk-oke"
  tenancy_ocid                  = var.tenancy_ocid
  compartment_ocid              = var.compartment_ocid
  cluster_type                  = "enhanced"
  k8s_version                   = "v1.31.1"
  node_linux_version            = "8.10"  
  oci_vcn_ip_native             = true
  use_existing_vcn              = false
  is_api_endpoint_subnet_public = true # OKE API Endpoint will be public (Internet facing)
  is_lb_subnet_public           = true # OKE LoadBalanacer will be public (Internet facing)
  is_nodepool_subnet_public     = false # OKE NodePool will be private (not-Internet facing)
  fk_oke_addon_map              = var.fk_oke_addon_map
}


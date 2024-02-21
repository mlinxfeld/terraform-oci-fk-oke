module "fk-oke" {
  providers                     = { oci = oci.targetregion }
  depends_on                    = [oci_identity_policy.fk_oke_virtual_node_pool_policy]
  source                        = "github.com/mlinxfeld/terraform-oci-fk-oke"
  tenancy_ocid                  = var.tenancy_ocid
  compartment_ocid              = var.compartment_ocid
  cluster_type                  = "enhanced"
  oci_vcn_ip_native             = true
  use_existing_vcn              = false
  is_api_endpoint_subnet_public = true # OKE API Endpoint will be public (Internet facing)
  is_lb_subnet_public           = true # OKE LoadBalanacer will be public (Internet facing)
  is_nodepool_subnet_public     = true # OKE NodePool will be public (Internet facing)
  virtual_node_pool             = true # Using Virtual Node Pool instead of Managed Node Pool
  pool_name                     = var.pool_name
  virtual_nodepool_pod_shape    = var.virtual_nodepool_pod_shape  
}


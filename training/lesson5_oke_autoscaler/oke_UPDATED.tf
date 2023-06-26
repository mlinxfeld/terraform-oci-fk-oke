module "fk-oke" {
  providers                     = { oci = oci.targetregion }
  depends_on                    = [oci_identity_policy.fk_oke_autoscaler_policy1, oci_identity_policy.fk_oke_autoscaler_policy2] 
  source                        = "../../" 
  #source                        = "github.com/mlinxfeld/terraform-oci-fk-oke"
  tenancy_ocid                  = var.tenancy_ocid
  compartment_ocid              = var.compartment_ocid
  cluster_type                  = "enhanced"
  k8s_version                   = var.kubernetes_version
  node_count                    = var.node_pool_size
  oci_vcn_ip_native             = true
  use_existing_vcn              = false
  is_api_endpoint_subnet_public = true # OKE API Endpoint will be public (Internet facing)
  is_lb_subnet_public           = true # OKE LoadBalanacer will be public (Internet facing)
  is_nodepool_subnet_public     = true # OKE NodePool will be public (Internet facing)
}


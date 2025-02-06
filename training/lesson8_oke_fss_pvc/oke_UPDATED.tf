module "fk-oke" {
  source                        = "github.com/mlinxfeld/terraform-oci-fk-oke"
  tenancy_ocid                  = var.tenancy_ocid
  compartment_ocid              = var.compartment_ocid
  cluster_type                  = "enhanced"
  k8s_version                   = "v1.31.1"
  node_linux_version            = "8.10"
  node_shape                    = var.oke_node_shape
  node_memory                   = var.oke_node_shape_memory
  node_ocpus                    = var.oke_node_shape_ocpus
  node_count                    = var.node_pool_size
  oci_vcn_ip_native             = true
  
  use_existing_vcn              = true
  vcn_id                        = oci_core_virtual_network.FoggyKitchenVCN.id

  is_api_endpoint_subnet_public = true # OKE API Endpoint will be public (Internet facing)
  api_endpoint_subnet_id        = oci_core_subnet.FoggyKitchenOKEAPIEndpointSubnet.id

  is_lb_subnet_public           = true # OKE LoadBalanacer will be public (Internet facing)
  lb_subnet_id                  = oci_core_subnet.FoggyKitchenOKELBSubnet.id

  is_nodepool_subnet_public     = false # OKE NodePool will be private (no Internet facing)
  nodepool_subnet_id            = oci_core_subnet.FoggyKitchenOKENodesPodsSubnet.id
  pods_subnet_id                = oci_core_subnet.FoggyKitchenOKENodesPodsSubnet.id
}


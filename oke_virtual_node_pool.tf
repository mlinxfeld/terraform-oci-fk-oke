resource "oci_containerengine_virtual_node_pool" "fk_oke_virtual_node_pool" {
    count          = var.virtual_node_pool ? 1 : 0
    cluster_id     = oci_containerengine_cluster.fk_oke_cluster.id
    compartment_id = var.compartment_ocid
    display_name   = var.pool_name
    
    dynamic "placement_configurations" {
      iterator = pc_iter
      for_each = local.availability_domains #data.oci_identity_availability_domains.ADs.availability_domains
      content {
        availability_domain = pc_iter.value.name
        fault_domain        = ["FAULT-DOMAIN-${(pc_iter.key % 3) + 1}"]
        subnet_id           = var.use_existing_vcn ? var.nodepool_subnet_id : oci_core_subnet.fk_oke_nodepool_subnet[0].id
      }
    }


    nsg_ids = var.use_existing_nsg ? var.virtual_nodepool_nsg_ids : []
    
    pod_configuration {
   
        shape = var.virtual_nodepool_pod_shape
        subnet_id =  var.use_existing_vcn ? var.nodepool_subnet_id : oci_core_subnet.fk_oke_nodepool_subnet[0].id

        nsg_ids = var.use_existing_nsg ? var.pods_nsg_ids : []
    }
    size = var.node_count
}


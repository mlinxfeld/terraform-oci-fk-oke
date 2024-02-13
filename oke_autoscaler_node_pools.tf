resource "oci_containerengine_node_pool" "fk_oke_autoscaler_node_pool" {
  depends_on         = [oci_containerengine_node_pool.fk_oke_node_pool]
  count              = var.virtual_node_pool ? 0 : var.autoscaler_enabled ? var.autoscaler_node_pool_count : 0
  cluster_id         = oci_containerengine_cluster.fk_oke_cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.k8s_version
  name               = "Autoscaler${var.pool_name}${count.index+1}"
  node_shape         = var.node_shape

  # oke specific images
  dynamic "node_source_details" {
    for_each = var.node_pool_image_type == "oke" ? [1] : []
    content {
      boot_volume_size_in_gbs = var.node_pool_boot_volume_size_in_gbs
      image_id = local.oke_specific_image_id
      source_type = data.oci_containerengine_node_pool_option.fk_oke_node_pool_option.sources[0].source_type
    }
  }

  # oci platform images
  dynamic "node_source_details" {
    for_each = var.node_pool_image_type == "platform" ? [1] : []
    content {
      boot_volume_size_in_gbs = var.node_pool_boot_volume_size_in_gbs
      image_id = local.oci_platform_image_id
      source_type = data.oci_containerengine_node_pool_option.fk_oke_node_pool_option.sources[0].source_type
    }
  }

  # custom images 
  dynamic "node_source_details" {
    for_each = var.node_pool_image_type == "custom" ? [1] : []
    content {
      boot_volume_size_in_gbs = var.node_pool_boot_volume_size_in_gbs
      image_id                = var.node_pool_image_id
      source_type             = data.oci_containerengine_node_pool_option.fk_oke_node_pool_option.sources[0].source_type
    }
  }

  ssh_public_key = var.ssh_public_key != "" ? var.ssh_public_key : tls_private_key.public_private_key_pair.public_key_openssh

  node_config_details {
    dynamic "placement_configs" {
      iterator = pc_iter
      for_each = local.availability_domains #data.oci_identity_availability_domains.ADs.availability_domains
      content {
        availability_domain = pc_iter.value.name        
        subnet_id           = var.use_existing_vcn ? var.nodepool_subnet_id : oci_core_subnet.fk_oke_nodepool_subnet[0].id
      }
    }
    size = var.node_count
   # defined_tags  = { "oke.pool" = "autoscaler" }

    dynamic "node_pool_pod_network_option_details" {
        for_each = var.oci_vcn_ip_native == true ? [1] : []
        content {
          cni_type          = "OCI_VCN_IP_NATIVE"
          max_pods_per_node = var.max_pods_per_node
          pod_nsg_ids       = var.use_existing_nsg ? var.pods_nsg_ids : []
          pod_subnet_ids    = var.use_existing_vcn ? [var.pods_subnet_id] :  [oci_core_subnet.fk_oke_nodepool_subnet[0].id]
        }
    }
  }

  dynamic "node_shape_config" {
    for_each = length(regexall("Flex", var.node_shape)) > 0 ? [1] : []
    content {
      ocpus         = var.node_ocpus
      memory_in_gbs = var.node_memory
    }
  }

  dynamic "node_eviction_node_pool_settings" {
    for_each = var.node_eviction_node_pool_settings == true ? [1] : []
    content {
    
        eviction_grace_duration = var.eviction_grace_duration
        is_force_delete_after_grace_duration = var.is_force_delete_after_grace_duration
    }
  }

}


resource "oci_containerengine_addon" "fk_oke_addon" {
    for_each = local.fk_oke_addon_map  
    addon_name = each.key
    cluster_id = oci_containerengine_cluster.fk_oke_cluster.id

    dynamic "configurations" {
        for_each = each.value.configurations
        content {
           key = configurations.key
           value = configurations.value.config_value
        }
   }

    remove_addon_resources_on_delete = true 
    version = each.value.addon_version
}

resource "oci_containerengine_addon" "fk_oke_autoscaler_addon" {
    count = var.virtual_node_pool ? 0 : var.autoscaler_enabled ? 1 : 0 
    addon_name = "ClusterAutoscaler"
    cluster_id = oci_containerengine_cluster.fk_oke_cluster.id

    configurations {
      key = "nodes"
      value = join("", [var.autoscaler_min_number_of_nodes,":",var.autoscaler_max_number_of_nodes,":",oci_containerengine_node_pool.fk_oke_autoscaler_node_pool[0].id])
    }
   
    configurations {
      key = "authType"
      value = "workload"
    }
    remove_addon_resources_on_delete = true
}

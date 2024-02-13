locals {

  compute_arm_shapes = [
    "VM.Standard.A1.Flex",
    "BM.Standard.A1"  
  ]
  is_arm_node_shape                       = contains(local.compute_arm_shapes, var.oke_node_shape) 

  http_port_number                        = "80"
  https_port_number                       = "443"
  oke_api_endpoint_port_number            = "6443"
  oke_nodes_to_control_plane_port_number  = "12250"
  ssh_port_number                         = "22"
  tcp_protocol_number                     = "6"
  icmp_protocol_number                    = "1"
  all_protocols                           = "all"
  oke_nodes_min_port                      = "30000"
  oke_nodes_max_port                      = "32767"
  lb_listener_port                        = var.lb_listener_port == "" ? "80" : var.lb_listener_port

  ocir_docker_repository   = join("", [lower(lookup(data.oci_identity_regions.oci_regions.regions[0], "key")), ".ocir.io"])
  ocir_namespace           = lookup(data.oci_objectstorage_namespace.test_namespace, "namespace")

}

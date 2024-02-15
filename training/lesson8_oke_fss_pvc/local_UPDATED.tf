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
  udp_protocol_number                     = "17"
  icmp_protocol_number                    = "1"
  all_protocols                           = "all"
  fss_port_1                              = "111"
  fss_port_2                              = "2048"
  fss_port_3                              = "2049"
  fss_port_4                              = "2050"
  oke_nodes_min_port                      = "30000"
  oke_nodes_max_port                      = "32767"
  lb_listener_port                        = var.lb_listener_port == "" ? "80" : var.lb_listener_port

}

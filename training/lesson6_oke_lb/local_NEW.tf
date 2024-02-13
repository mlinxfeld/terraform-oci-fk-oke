locals {

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

}

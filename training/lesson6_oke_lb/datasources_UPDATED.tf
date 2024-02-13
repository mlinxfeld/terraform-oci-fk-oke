data "template_file" "nginx_deployment" {

  template = "${file("${path.module}/manifest/nginx.template.yaml")}"
  vars     = {
      number_of_nginx_replicas = "${var.number_of_nginx_replicas}"
  }
}

data "template_file" "service_deployment" {

  template = "${file("${path.module}/manifest/service.template.yaml")}"
  vars     = {
      lb_shape                      = var.lb_shape
      flex_lb_min_shape             = var.flex_lb_min_shape 
      flex_lb_max_shape             = var.flex_lb_max_shape  
      lb_listener_port              = var.lb_listener_port
      lb_nsg                        = var.lb_nsg
      lb_nsg_id                     = var.lb_nsg ? oci_core_network_security_group.FoggyKitchenOKELBSecurityGroup[0].id : ""
      use_reserved_public_ip_for_lb = var.use_reserved_public_ip_for_lb
      reserved_public_ip_for_lb     = var.use_reserved_public_ip_for_lb ? oci_core_public_ip.FoggyKitchenReservedPublicIP[0].ip_address : ""
  }
}

data "oci_core_services" "FoggyKitchenAllOCIServices" {
  provider       = oci.targetregion

  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

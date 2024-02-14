data "template_file" "storageclass_deployment" {

  template = "${file("${path.module}/manifest/storageclass.template.yaml")}"
  vars     = {
      fs_type     = var.fs_type
      vpus_per_gb = var.vpus_per_gb
  }
}

data "template_file" "pvc_deployment" {

  template = "${file("${path.module}/manifest/pvc.template.yaml")}"
  vars     = {
      pvc_from_existing_block_volume = var.pvc_from_existing_block_volume
      block_volume_name              = var.pvc_from_existing_block_volume ? oci_core_volume.FoggyKitchenBlockVolume[0].display_name : var.block_volume_name
      block_volume_id                = var.pvc_from_existing_block_volume ? oci_core_volume.FoggyKitchenBlockVolume[0].id : ""
      block_volume_size              = var.pvc_from_existing_block_volume ? oci_core_volume.FoggyKitchenBlockVolume[0].size_in_gbs : var.block_volume_size
  }
}

data "template_file" "nginx_deployment" {

  template = "${file("${path.module}/manifest/nginx.template.yaml")}"
  vars     = {
      block_volume_name = var.pvc_from_existing_block_volume ? oci_core_volume.FoggyKitchenBlockVolume[0].display_name : var.block_volume_name
      is_arm_node_shape = local.is_arm_node_shape
  }
}

data "template_file" "service_deployment" {

  template = "${file("${path.module}/manifest/service.template.yaml")}"
  vars     = {
      lb_shape          = var.lb_shape
      flex_lb_min_shape = var.flex_lb_min_shape 
      flex_lb_max_shape = var.flex_lb_max_shape  
      lb_listener_port  = var.lb_listener_port
      lb_nsg            = var.lb_nsg
      lb_nsg_id         = var.lb_nsg ? oci_core_network_security_group.FoggyKitchenOKELBSecurityGroup[0].id : ""
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

data "oci_identity_availability_domains" "ADs" {
  provider       = oci.targetregion
  compartment_id = var.tenancy_ocid
}


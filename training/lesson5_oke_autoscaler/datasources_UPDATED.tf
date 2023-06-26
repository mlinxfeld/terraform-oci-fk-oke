data "oci_identity_region_subscriptions" "home_region_subscriptions" {

  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

data "template_file" "autoscaler_deployment" {

  template = "${file("${path.module}/manifest/autoscaler.template.yaml")}"
  vars     = {
      autoscaler_image = "${lookup(local.autoscaler_image, var.kubernetes_version)}"
      min_nodes        = "${var.min_number_of_nodes}"
      max_nodes        = "${var.max_number_of_nodes}"
      node_pool_id     = "${join("",module.fk-oke.node_pool.id)}"
  }
}

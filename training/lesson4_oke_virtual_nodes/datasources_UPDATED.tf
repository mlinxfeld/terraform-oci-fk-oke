data "template_file" "nginx_deployment" {

  template = "${file("${path.module}/manifest/nginx.template.yaml")}"
  vars     = {
      number_of_ngnix_replicas = "${var.number_of_nginx_replicas}"
  }
}

data "oci_identity_region_subscriptions" "home_region_subscriptions" {

  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

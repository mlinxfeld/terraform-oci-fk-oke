data "template_file" "nginx_deployment" {

  template = "${file("${path.module}/manifest/nginx.template.yaml")}"
  vars     = {
      number_of_ngnix_replicas = "${var.number_of_nginx_replicas}"
  }
}

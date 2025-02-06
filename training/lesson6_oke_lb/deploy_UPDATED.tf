resource "local_file" "nginx_deployment" {
  content = templatefile("${path.module}/manifest/nginx.template.yaml", {
    number_of_nginx_replicas = var.number_of_nginx_replicas
  })
  filename = "${path.module}/nginx.yaml"
}

resource "local_file" "service_deployment" {
  content = templatefile("${path.module}/manifest/service.template.yaml" , {
      lb_shape                      = var.lb_shape
      flex_lb_min_shape             = var.flex_lb_min_shape 
      flex_lb_max_shape             = var.flex_lb_max_shape  
      lb_listener_port              = var.lb_listener_port
      lb_nsg                        = var.lb_nsg
      lb_nsg_id                     = var.lb_nsg ? oci_core_network_security_group.FoggyKitchenOKELBSecurityGroup[0].id : ""
      use_reserved_public_ip_for_lb = var.use_reserved_public_ip_for_lb
      reserved_public_ip_for_lb     = var.use_reserved_public_ip_for_lb ? oci_core_public_ip.FoggyKitchenReservedPublicIP[0].ip_address : ""
  })
  filename = "${path.module}/service.yaml"
}

resource "null_resource" "deploy_nginx" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool, 
  local_file.nginx_deployment,
  local_file.service_deployment]

  provisioner "local-exec" {
    command = "oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${module.fk-oke.cluster.id}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.nginx_deployment.filename}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.service_deployment.filename}"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "local-exec" {
    command = "kubectl get pods"
  }

  provisioner "local-exec" {
    command = "kubectl get services"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete service lb-service"
  }

}

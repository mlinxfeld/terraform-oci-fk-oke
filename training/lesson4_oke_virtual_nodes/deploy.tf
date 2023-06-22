resource "local_file" "nginx_deployment" {
  content  = data.template_file.nginx_deployment.rendered
  filename = "${path.module}/nginx.yaml"
}

resource "null_resource" "deploy_nginx" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool, 
  local_file.nginx_deployment]

  provisioner "local-exec" {
    command = "oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${module.fk-oke.cluster.id}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.nginx_deployment.filename}"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "local-exec" {
    command = "kubectl get pods"
  }

  provisioner "local-exec" {
    command = "kubectl describe  pods | grep '  IP:'"
  }

}

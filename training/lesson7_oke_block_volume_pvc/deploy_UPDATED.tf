resource "local_file" "storageclass_deployment" {
  content  = data.template_file.storageclass_deployment.rendered
  filename = "${path.module}/storageclass.yaml"
}

resource "local_file" "pvc_deployment" {
  content  = data.template_file.pvc_deployment.rendered
  filename = "${path.module}/pvc.yaml"
}

resource "local_file" "nginx_deployment" {
  content  = data.template_file.nginx_deployment.rendered
  filename = "${path.module}/nginx.yaml"
}

resource "local_file" "service_deployment" {
  content  = data.template_file.service_deployment.rendered
  filename = "${path.module}/service.yaml"
}

resource "null_resource" "deploy_oke_pvc" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool,
  local_file.storageclass_deployment,
  local_file.pvc_deployment,
  local_file.nginx_deployment,
  local_file.service_deployment]

  provisioner "local-exec" {
    command = "oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${module.fk-oke.cluster.id}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.storageclass_deployment.filename}  --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.pvc_deployment.filename}  --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "local-exec" {
    command = "kubectl get pvc"
  }

}

resource "null_resource" "deploy_oke_nginx" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool,
  local_file.pvc_deployment,
  local_file.nginx_deployment,
  null_resource.deploy_oke_pvc]

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.nginx_deployment.filename}  --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.service_deployment.filename}  --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "local-exec" {
    command = "kubectl describe pod nginx"
  }

  provisioner "local-exec" {
    command = "kubectl get services"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete service lb-service"
  }

}



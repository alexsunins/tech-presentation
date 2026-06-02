resource "kubectl_manifest" "k8s_resource" {
  yaml_body = templatefile("${path.module}/manifest.tpl", { body = var.manifest.yaml_body })
}

resource "time_sleep" "wait_timer" {
  count = (var.wait_after_create == null || var.wait_after_create == "0s") ? 0 : 1

  create_duration = var.wait_after_create

  depends_on = [
    kubectl_manifest.k8s_resource
  ]
}

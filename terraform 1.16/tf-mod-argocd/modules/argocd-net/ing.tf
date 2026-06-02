## GCP Global address for k8 ingress
resource "google_compute_global_address" "argocd_global_ip_address" {
  name = var.argocd_external_ip_name
}


# shared resources that are required for the ingress
resource "kubectl_manifest" "argocd_ingress" {
  depends_on = [
    google_compute_global_address.argocd_global_ip_address
  ]

  for_each = toset(local.yaml_manifest_deployment_order.shared)

  yaml_body = templatefile("${path.module}/manifests/shared/${each.value}", {
    namespace_name        = var.argocd_namespace,
    dns_name              = var.dns_name,
    ssl_certificate_name  = local.ssl_certificate_name,
    fe_config_name        = local.fe_config_name,
    global_static_ip_name = var.argocd_external_ip_name,
    manifest_fingerprint  = sha1(file("${path.module}/manifests/shared/${each.value}"))
  })
}


resource "time_sleep" "wait_for_ingress" {
  depends_on = [
    kubectl_manifest.argocd_ingress
  ]

  create_duration = var.ingress_wait_time
}

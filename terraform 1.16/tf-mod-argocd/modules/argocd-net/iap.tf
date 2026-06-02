resource "kubectl_manifest" "oauth_secret" {
  depends_on = [
    kubectl_manifest.argocd_ingress
  ]

  count = var.secure_with_iap == null ? 0 : 1

  yaml_body = templatefile("${path.module}/manifests/shared/iap.oauth_secret.yaml", {
    namespace_name       = var.argocd_namespace,
    secret_name          = local.k8s_secret_name,
    manifest_fingerprint = sha1(format("%s,%s", var.secure_with_iap.client_id, var.secure_with_iap.client_secret)),
    client_id            = base64encode(var.secure_with_iap.client_id),
    client_secret        = base64encode(var.secure_with_iap.client_secret)
  })
}


resource "kubectl_manifest" "iap_backend_config" {
  depends_on = [
    kubectl_manifest.argocd_ingress
  ]

  count = var.secure_with_iap == null ? 0 : 1

  yaml_body = templatefile("${path.module}/manifests/shared/iap.becfg.yaml", {
    namespace_name       = var.argocd_namespace,
    manifest_fingerprint = sha1(file("${path.module}/manifests/shared/iap.becfg.yaml"))
    k8s_secret_for_oauth = local.k8s_secret_name,
    becfg_name           = local.iap_becfg_name
  })
}


# annotation for ArgoCD service that enables IAP
resource "kubernetes_annotations" "becfg_annotation" {
  depends_on = [
    kubectl_manifest.iap_backend_config
  ]

  count = var.secure_with_iap == null ? 0 : 1

  api_version = "v1"
  kind        = "Service"

  metadata {
    name      = "argocd-server"
    namespace = var.argocd_namespace
  }

  annotations = local.iap_annotation_all_ports
}

locals {
  manifest_deployment_order = [
    "ServiceAccount.argocd-notifications-controller.yaml",
    "Role.argocd-notifications-controller.yaml",
    "RoleBinding.argocd-notifications-controller.yaml",
    "ConfigMap.argocd-notifications-cm.yaml",
    "ConfigMap.argocd-tls-certs-cm.yaml",
    "Secret.argocd-notifications-secret.yaml",
    "Service.argocd-notifications-controller-metrics.yaml",
    "Deployment.argocd-notifications-controller.yaml"
  ]
}


## Manifest bundle
resource "kubectl_manifest" "argocd_notifications" {
  for_each = toset(local.manifest_deployment_order)

  yaml_body = templatefile("${path.module}/manifests/${each.key}", {
    namespace   = var.namespace,
    app_version = var.app_version
  })
}

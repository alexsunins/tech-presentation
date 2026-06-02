# Resources that are required for ArgoCD App for Apps
# ClusterRole and ClusterRoleBindings that are required to allow the Argo CD API Server (argocd-server) to perform CRUD operations on Application CRs in all namespaces on the cluster.
resource "kubectl_manifest" "clusterrole_app_cupd" {
  count = length(var.app_for_apps.application_namespaces) == 0 ? 0 : 1

  yaml_body = templatefile("${path.module}/manifests/argocd/clusterrole_argocd-server-cluster-apps.yaml", {})
}


resource "kubectl_manifest" "clusterrolebinding_app_cupd" {
  count = length(var.app_for_apps.application_namespaces) == 0 ? 0 : 1

  yaml_body = templatefile("${path.module}/manifests/argocd/clusterrolebinding_argocd-server-cluster-apps.yaml", {
    namespace_name = local.argocd_k8s_namespace
  })
}


resource "kubectl_manifest" "clusterrole_app_luwp_notifications_controller" {
  count = length(var.app_for_apps.application_namespaces) == 0 ? 0 : 1

  yaml_body = templatefile("${path.module}/manifests/argocd/clusterrole_argocd-notifications-controller-cluster-apps.yaml", {})
}


resource "kubectl_manifest" "clusterrolebinding_luwp_notifications_controller" {
  count = length(var.app_for_apps.application_namespaces) == 0 ? 0 : 1

  yaml_body = templatefile("${path.module}/manifests/argocd/clusterrolebinding_argocd-notifications-controller-cluster-apps.yaml", {
    namespace_name = local.argocd_k8s_namespace
  })
}

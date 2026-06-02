locals {
  argocd_k8s_namespace               = var.argocd_namespace == null ? "argocd" : var.argocd_namespace
  dex_template_name                  = var.enable_google_sso == null ? "deployment_argocd-dex-server.yaml" : "deployment_argocd-dex-server-sso-enabled.yaml"
  argocd_cm_template                 = var.enable_google_sso == null ? "configmap_argocd-cm.yaml" : "configmap_argocd-cm-dex-enabled.yaml"
  argocd_cmd_cm_template             = length(var.app_for_apps.application_namespaces) == 0 ? "configmap_argocd-cmd-params-cm.yaml" : "configmap_argocd-cmd-params-cm_app_for_apps.yaml"
  argocd_server_clusterrole_template = var.app_config.allow_pod_exec == "false" ? "clusterrole_argocd-server.yaml" : "clusterrole_argocd-server-exec-enabled.yaml"
  argocd_server_role_template        = var.app_config.allow_pod_exec == "false" ? "role_argocd-server.yaml" : "role_argocd-server-exec-enabled.yaml"
  app_for_apps_namespaces            = contains(var.app_for_apps.application_namespaces, "*") ? "\"*\"" : join(", ", var.app_for_apps.application_namespaces)
}

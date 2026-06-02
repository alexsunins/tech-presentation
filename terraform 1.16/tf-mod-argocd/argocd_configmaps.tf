# if var.enable_google_sso is not null then need to add dex.config to argocd-cm, otherwise deploy stock argocd-cm
resource "kubectl_manifest" "argocd_cm" {
  depends_on = [
    kubectl_manifest.argocd_namespace
  ]

  yaml_body = templatefile("${path.module}/manifests/argocd/${local.argocd_cm_template}", {
    namespace_name           = local.argocd_k8s_namespace,
    timeout_reconciliation   = var.app_config.timeout_reconciliation,
    dex_client_id            = var.enable_google_sso.dex_oauth_client.client_id,
    dex_client_secret        = var.enable_google_sso.dex_oauth_client.client_secret,
    dex_admin_email          = var.enable_google_sso.admin_user_email_address,
    dns_name                 = var.dns_name,
    pod_exec                 = var.app_config.allow_pod_exec,
    resource_tracking_method = var.resource_tracking_method
  })
}


# If app-for-apps pattern is not used then need to deploy stock configmap_argocd-cmd-params-cm.yaml, else configmap_argocd-cmd-params-cm_app_for_apps.yaml
resource "kubectl_manifest" "argocd_cmd_params_cm" {
  depends_on = [
    kubectl_manifest.argocd_namespace
  ]

  yaml_body = templatefile("${path.module}/manifests/argocd/${local.argocd_cmd_cm_template}", {
    namespace_name         = local.argocd_k8s_namespace,
    application_namespaces = local.app_for_apps_namespaces
  })
}


# ArgoCD relies on SSH Known Hosts in order to add repositories from a VCS (e.g. GitHub, GitLab, BitBucket, etc).
# Once a tracked VCS rotates its SSH keys need to update relevant configmap with the new results of ssh-keyscan
resource "kubectl_manifest" "ssh_known_hosts_configmap" {
  count = var.ssh_known_hosts == null ? 1 : 0

  yaml_body = templatefile("${path.module}/manifests/argocd/configmap_argocd-ssh-known-hosts-cm.yaml", {
    namespace_name = local.argocd_k8s_namespace,
  })
}


resource "kubernetes_config_map" "ssh_known_hosts_configmap" {
  count = var.ssh_known_hosts == null ? 0 : 1

  metadata {
    name      = "argocd-ssh-known-hosts-cm"
    namespace = local.argocd_k8s_namespace
    labels = {
      "app.kubernetes.io/name"    = "argocd-ssh-known-hosts-cm"
      "app.kubernetes.io/part-of" = "argocd"
    }
  }

  data = {
    ssh_known_hosts = var.ssh_known_hosts
  }
}

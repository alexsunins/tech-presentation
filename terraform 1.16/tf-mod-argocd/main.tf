## ArgoCD namespace
resource "kubectl_manifest" "argocd_namespace" {
  count = var.create_namespace ? 1 : 0
  yaml_body = templatefile("${path.module}/manifests/shared/01_namespace.yaml", {
    namespace_name = local.argocd_k8s_namespace
  })
}

locals {
  argocd_manifest_deployment_order = [
    "crd_applications.argoproj.io.yaml",
    "crd_applicationsets.argoproj.io.yaml",
    "crd_appprojects.argoproj.io.yaml",
    "sa_argocd-application-controller.yaml",
    "sa_argocd-applicationset-controller.yaml",
    "sa_argocd-dex-server.yaml",
    "sa_argocd-notifications-controller.yaml",
    "sa_argocd-redis.yaml",
    "sa_argocd-repo-server.yaml",
    "sa_argocd-server.yaml",
    "role_argocd-application-controller.yaml",
    "role_argocd-applicationset-controller.yaml",
    "role_argocd-dex-server.yaml",
    "role_argocd-notifications-controller.yaml",
    # "role_argocd-server.yaml",
    "clusterrole_argocd-application-controller.yaml",
    # "clusterrole_argocd-server.yaml",
    "rolebinding_argocd-application-controller.yaml",
    "rolebinding_argocd-applicationset-controller.yaml",
    "rolebinding_argocd-dex-server.yaml",
    "rolebinding_argocd-notifications-controller.yaml",
    "rolebinding_argocd-redis.yaml",
    "rolebinding_argocd-server.yaml",
    "clusterrolebinding_argocd-application-controller.yaml",
    "clusterrolebinding_argocd-server.yaml",
    #"configmap_argocd-cm.yaml",
    # "configmap_argocd-cmd-params-cm.yaml",
    "configmap_argocd-gpg-keys-cm.yaml",
    "configmap_argocd-notifications-cm.yaml",
    "configmap_argocd-rbac-cm.yaml",
    #"configmap_argocd-ssh-known-hosts-cm.yaml",
    "configmap_argocd-tls-certs-cm.yaml",
    "secret_argocd-notifications-secret.yaml",
    "secret_argocd-secret.yaml",
    "service_argocd-applicationset-controller.yaml",
    "service_argocd-dex-server.yaml",
    "service_argocd-metrics.yaml",
    "service_argocd-notifications-controller-metrics.yaml",
    "service_argocd-redis.yaml",
    "service_argocd-repo-server.yaml",
    "service_argocd-server-metrics.yaml",
    # "service_argocd-server.yaml",
    "deployment_argocd-applicationset-controller.yaml",
    # "deployment_argocd-dex-server.yaml",
    "deployment_argocd-notifications-controller.yaml",
    "deployment_argocd-redis.yaml",
    "deployment_argocd-repo-server.yaml",
    "deployment_argocd-server.yaml",
    "statefulset_argocd-application-controller.yaml",
    "networkpolicy_argocd-application-controller-network-policy.yaml",
    "networkpolicy_argocd-applicationset-controller-network-policy.yaml",
    "networkpolicy_argocd-dex-server-network-policy.yaml",
    "networkpolicy_argocd-notifications-controller-network-policy.yaml",
    "networkpolicy_argocd-redis-network-policy.yaml",
    "networkpolicy_argocd-repo-server-network-policy.yaml",
    "networkpolicy_argocd-server-network-policy.yaml"
  ]
}


# if app_config.allow_pod_exec is set to `true` then need to deploy patched config, otherwise deploy stock argocd-server role
resource "kubectl_manifest" "argocd_server_role" {
  depends_on = [
    kubectl_manifest.argocd_cm
  ]

  yaml_body = templatefile("${path.module}/manifests/argocd/${local.argocd_server_role_template}", {
    namespace_name = local.argocd_k8s_namespace
  })
}


# if app_config.allow_pod_exec is set to `true` then need to deploy patched config, otherwise deploy stock argocd-server clusterrole
resource "kubectl_manifest" "argocd_server_clusterrole" {
  depends_on = [
    kubectl_manifest.argocd_server_role
  ]

  yaml_body = templatefile("${path.module}/manifests/argocd/${local.argocd_server_clusterrole_template}", {})
}


## ArgoCD resource bundle
resource "kubectl_manifest" "argocd" {
  depends_on = [
    kubectl_manifest.argocd_namespace
  ]

  for_each = toset(local.argocd_manifest_deployment_order)

  yaml_body = templatefile("${path.module}/manifests/argocd/${each.key}", {
    namespace_name         = local.argocd_k8s_namespace,
    app_version            = var.app_version,
    timeout_reconciliation = var.app_config.timeout_reconciliation
  })
}


# if expose_services set to true then argocd-server will be deployed and controller by argocd_networking module, 
# otherwise need to deploy stock YAML for argocd-server
resource "kubectl_manifest" "argocd_service" {
  depends_on = [
    kubectl_manifest.argocd
  ]

  count = var.expose_services == null ? 1 : 0

  yaml_body = templatefile("${path.module}/manifests/argocd/service_argocd-server.yaml", {
    namespace_name = local.argocd_k8s_namespace
  })
}


# if enable_google_sso is not null then need to deploy a secret that stores base64 encoded service account key
resource "kubectl_manifest" "service_account_key" {
  depends_on = [
    kubectl_manifest.argocd
  ]

  count = var.enable_google_sso == null ? 0 : 1

  yaml_body = templatefile("${path.module}/manifests/google-sso/argocd-google-groups-json.yaml", {
    namespace_name           = local.argocd_k8s_namespace,
    json_file_base64_encoded = var.enable_google_sso.service_account_key
  })
}


# if var.enable_google_sso is not null then need to deploy a template for DeX server that has different volume mounts,
# otherwise deploy the default template
resource "kubectl_manifest" "dex_server_deployment" {
  depends_on = [
    kubectl_manifest.argocd,
    kubectl_manifest.service_account_key
  ]

  yaml_body = templatefile("${path.module}/manifests/argocd/${local.dex_template_name}", {
    namespace_name = local.argocd_k8s_namespace,
    app_version    = var.app_version
  })
}


## ArgoCD networking
module "argocd_networking" {
  depends_on = [
    kubectl_manifest.argocd
  ]

  count = var.expose_services == null ? 0 : 1

  source = "./modules/argocd-net"

  argocd_namespace        = local.argocd_k8s_namespace
  argocd_external_ip_name = var.external_ip_address_for_ingress.name
  argocd_regional_ip      = var.regional_ip_address_for_argocd_service
  dns_name                = var.dns_name

  secure_with_iap = var.iap
}


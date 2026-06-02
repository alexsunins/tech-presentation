locals {
  yaml_manifest_deployment_order = {
    shared = [
      "01_cert.yaml",
      "02_fe.yaml",
      "03_ing.yaml"
    ]

    vpc_native = [
      "01_svc.yaml",
      "02_becfg_healthz.yaml",
    ]
  }

  fe_config_name       = "argocd-frontend-config"
  ssl_certificate_name = "argocd-certificate"
  k8s_secret_name      = "argocd-oauth-secret"

  iap_becfg_name = "argocd-backend-config-iap"

  iap_annotation_all_ports = {
    "beta.cloud.google.com/backend-config" = jsonencode({ "default" = local.iap_becfg_name })
  }
}


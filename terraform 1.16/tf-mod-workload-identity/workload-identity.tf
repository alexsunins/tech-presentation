resource "random_string" "rnd_str" {
  count   = var.insert_random_string ? 1 : 0
  length  = 6
  special = false
  upper   = false
}


locals {
  wi_gsa            = var.insert_random_string ? "${var.application_name}-${random_string.rnd_str[0].result}-gsa" : "${var.application_name}-gsa"
  wi_ksa_name       = "${var.application_name}-ksa"
  wi_ksa_token_name = "${var.application_name}-ksa-token"
  wi_ksa_gcp_name   = "serviceAccount:${var.project_id}.svc.id.goog[${var.k8s_namespace}/${local.wi_ksa_name}]"
}


module "wi_gsa" {
  source = "<path_tf-mod-gcp-service-account_on_github>"

  service_account_name         = local.wi_gsa
  service_account_description  = "Google SA for GKE Workload Identity - ${var.application_name}"
  project_level_iam_grants     = var.project_level_iam_grants
  non_project_level_iam_grants = var.non_project_level_iam_grants
}


resource "google_service_account_iam_member" "wi_gsa" {
  service_account_id = module.wi_gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.wi_ksa_gcp_name
}


resource "kubernetes_service_account_v1" "ksa" {
  depends_on = [
    module.wi_gsa.email
  ]

  metadata {
    name      = local.wi_ksa_name
    namespace = var.k8s_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.wi_gsa.email
    }
  }
}


resource "kubernetes_secret_v1" "ksa_token" {
  depends_on = [
    kubernetes_service_account_v1.ksa
  ]

  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = local.wi_ksa_name
    }
    namespace = var.k8s_namespace
    name      = local.wi_ksa_token_name
  }

  type = "kubernetes.io/service-account-token"

  wait_for_service_account_token = true
}

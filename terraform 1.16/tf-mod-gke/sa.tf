### Service Account
module "gke_cluster_sa" {
  source = "path_to_the_tf-mod-gcp-service-account_module_on_github"

  service_account_name_prefix = "sa-gke"
  service_account_description = "${var.cluster_name} GKE Cluster Service Account"
  project_id                  = var.project_id
  service_account_iam_roles   = var.gke_sa_roles
}


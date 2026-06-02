module "backup_plan" {
  source = "path_to_the_tf-mod-backup-for-gke_module_on_github"

  count = var.gke_backup_plan == null ? 0 : 1

  gke_cluster = {
    id       = google_container_cluster.gke_cluster.id
    name     = var.cluster_name
    location = local.region
  }

  config = {
    backup_retain_days = var.gke_backup_plan.backup_retain_days
    backup_schedule    = var.gke_backup_plan.backup_schedule
    backup_assets = {
      include_volume_data = var.gke_backup_plan.backup_config.include_volume_data
      include_secrets     = var.gke_backup_plan.backup_config.include_secrets
      namespaces          = var.gke_backup_plan.backup_config.namespaces
    }
  }
}

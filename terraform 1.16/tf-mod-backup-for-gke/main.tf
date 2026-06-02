locals {
  backup_all_ns = contains(var.config.backup_assets.namespaces, "all")
}


resource "google_gke_backup_backup_plan" "basic" {
  name     = var.name == null ? "${var.gke_cluster.name}-backup-plan" : var.name
  cluster  = var.gke_cluster.id
  location = var.gke_cluster.location

  retention_policy {
    backup_retain_days = var.config.backup_retain_days
  }

  backup_schedule {
    cron_schedule = var.config.backup_schedule
  }

  backup_config {
    include_volume_data = var.config.backup_assets.include_volume_data
    include_secrets     = var.config.backup_assets.include_secrets
    all_namespaces      = local.backup_all_ns ? local.backup_all_ns : null

    dynamic "selected_namespaces" {
      for_each = local.backup_all_ns ? [] : [1]
      content {
        namespaces = var.config.backup_assets.namespaces
      }
    }
  }
}

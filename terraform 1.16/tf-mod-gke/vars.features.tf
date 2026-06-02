# Variables related to the GKE cluster features

variable "enable_cluster_features" {
  type        = list(string)
  default     = []
  description = <<EOD
    The following cluster features wlll be enabled if the list contains following values:

    backup_for_gke  = Backup for GKE will be enabled
    maintenance     = a maintenance window will be configured.
                      If this item is added to this list then either var.daily_maintenance_window or var.recurring_maintenance_window is expected
  EOD
}


variable "gke_backup_plan" {
  description = <<EOD
    If not null then Backup for GKE backup plan will be created.

    The backup plan options:

      backup_retain_days => The default maximum age of a Backup created via this BackupPlan. This field MUST be an integer value >= 0 and <= 365.
      backup_schedule    = A standard cron string that defines a repeating schedule for creating Backups via this BackupPlan.
        NOTE: backup_plans with schedule defined must also set backup_retain_days (backup_retain_days > 0)
      backup_config = {
        include_volume_data = This flag specifies whether volume data should be backed up when PVCs are included in the scope of a Backup.
        include_secrets     = This flag specifies whether Kubernetes Secret resources should be included when they fall into the scope of Backups.
        namespaces          = list of strings. If the list contains "all" then all namespaces will be backed up, otherwise selected_namespaces block will be generated.
      }

  EOD


  type = object({
    backup_retain_days = number
    backup_schedule    = string
    backup_config = object({
      include_volume_data = bool
      include_secrets     = bool
      namespaces          = list(string)
    })
  })

  default = null
}


variable "google_groups_for_rbac" {
  default = null
  type = object({
    security_group_email_address = string
  })
  description = <<EOD
    If not null will configure the cluster for use with Google Groups.
    
    security_group_email_address =  The name of the RBAC security group for use with Google security groups in Kubernetes RBAC.
                                    Group name must be in format gke-security-groups@yourdomain.com
  EOD
}


variable "istio_addon" {
  type = object({
    enabled = bool
    auth    = string
  })

  default = {
    enabled = false
    auth    = "AUTH_MUTUAL_TLS"
  }

  description = "Whether to enable Istio add-on"
}


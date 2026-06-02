variable "name" {
  description = "The name of the backup plan"
  type        = string
  default     = null
}


variable "gke_cluster" {
  type = object({
    id       = string
    name     = string
    location = string
  })

  description = <<EOD
        id          = Id of GKE cluster, in format projects/{{project}}/locations/{{zone}}/clusters/{{name}}
        name        = the name of GKE cluster to apply the plan on
        location    = GKE cluster location
    EOD
}

variable "config" {
  description = <<EOD
    If not null then GKE backup will be enabled and a backup plan will be created.

    The backup plan options:

      backup_retain_days => The default maximum age of a Backup created via this BackupPlan. This field MUST be an integer value >= 0 and <= 365.
      backup_schedule    = A standard cron string that defines a repeating schedule for creating Backups via this BackupPlan.
        NOTE: backup_plans with schedule defined must also set backup_retain_days (backup_retain_days > 0)
      backup_assets = {
        include_volume_data = This flag specifies whether volume data should be backed up when PVCs are included in the scope of a Backup.
        include_secrets     = This flag specifies whether Kubernetes Secret resources should be included when they fall into the scope of Backups.
        namespaces          = list of strings. If the list contains "all" then all namespaces will be backed up, otherwise selected_namespaces block will be generated.
      }

  EOD


  type = object({
    backup_retain_days = number
    backup_schedule    = string
    backup_assets = object({
      include_volume_data = bool
      include_secrets     = bool
      namespaces          = list(string)
    })
  })

  default = null
}

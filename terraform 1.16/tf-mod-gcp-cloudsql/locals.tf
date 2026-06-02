locals {
  default_database_flags = [
    {
      name  = "log_temp_files"
      value = "0"
    },
    {
      name  = "log_connections"
      value = "on"
    },
    {
      name  = "log_lock_waits"
      value = "on"
    },
    {
      name  = "log_disconnections"
      value = "on"
    },
    {
      name  = "log_checkpoints"
      value = "on"
    }
  ]

  database_flags = distinct(concat(local.default_database_flags, var.database_flags))
}
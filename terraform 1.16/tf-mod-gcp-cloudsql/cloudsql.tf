resource "google_sql_database_instance" "pgdb" {
  name                = var.db_instance_name
  database_version    = var.pg_db_version
  region              = var.region
  deletion_protection = var.protect_from_deletion

  settings {
    tier              = var.db_machine_type
    availability_type = var.availability_type
    disk_autoresize   = var.disk_autoresize
    disk_type         = var.disk_type
    user_labels       = var.labels

    insights_config {
      query_insights_enabled  = var.query_insights_enabled
      query_string_length     = var.query_insights_config.query_string_length
      record_application_tags = var.query_insights_config.record_application_tags
      record_client_address   = var.query_insights_config.record_client_address
      query_plans_per_minute  = var.query_insights_config.query_plans_per_minute
    }

    backup_configuration {
      enabled    = var.backup_configuration.enabled
      start_time = var.backup_configuration.start_time
      location   = var.region
    }

    ip_configuration {
      ipv4_enabled    = var.enable_public_ip
      private_network = var.network_id // Specifying a network (VPC) enables private IP.

      require_ssl = true
    }

    dynamic "maintenance_window" {
      for_each = var.maintenance_window == null ? [] : [1]
      content {
        day          = var.maintenance_window.day
        hour         = var.maintenance_window.hour
        update_track = var.maintenance_window.update_track
      }
    }

    dynamic "database_flags" {
      for_each = local.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }
  }
}

variable "project_id" {
  description = "GCP Project ID."
  type        = string
}


variable "region" {
  description = "GCP region for the instance."
  type        = string
}


variable "labels" {
  description = "Labels to assign to the GCP resources."
  type        = map(any)
}


variable "network_id" {
  type        = string
  description = "Network id peered with servicenetworking."
}


variable "enable_public_ip" {
  description = <<EOT
    Whether this Cloud SQL instance should be assigned a public IPV4 address.
    At least ip_configuration.ipv4_enabled must be enabled or a ip_configuration.private_network must be configured.
  EOT

  type    = bool
  default = false
}


variable "db_instance_name" {
  type        = string
  description = "Postgres CloudSQL Instance name."
}


variable "pg_db_version" {
  description = "Postgres SQL DB version"
  type        = string
  default     = "POSTGRES_12"
}


variable "db_machine_type" {
  description = "DB instance machine type."
  type        = string
}


variable "availability_type" {
  description = "The availability type of the Cloud SQL instance. `REGIONAL` for high availability or `ZONAL` for single zone."
  type        = string
}


variable "disk_autoresize" {
  description = "Configuration to increase storage size automatically."
  type        = bool
  default     = true
}


variable "disk_type" {
  description = "The type of data disk: `PD_SSD` or `PD_HDD`."
  type        = string
  default     = "PD_SSD"
}


variable "backup_configuration" {
  description = "Cloud SQL backup configuration."

  type = object({
    enabled    = bool
    start_time = string
  })

  default = {
    enabled    = true,
    start_time = "03:00"
  }
}


variable "maintenance_window" {
  description = "Cloud SQL maintenance window."

  type = object({
    day          = string
    hour         = string
    update_track = string
  })

  default = null
}


variable "protect_from_deletion" {
  description = "Flag to enable deletion protection of Cloud SQL instance. Defaults to `false`."
  type        = bool
  default     = false
}


variable "read_replica" {
  description = <<EOT
    If not null, will deploy a read replica.

    delete_protection = Flag to enable deletion protection of Cloud SQL read replica.
    availability_type = The availability type of the Cloud SQL instance. `REGIONAL` for high availability or `ZONAL` for single zone.
    zone              = Zone preference for Read Replica.
  EOT

  type = object({
    delete_protection = bool
    availability_type = string
    zone              = string
  })

  default = null
}


variable "pg_user" {
  description = "User credentials that can be used to connect to the instance."
  type = object({
    name     = string
    password = string
  })

  default   = null
  sensitive = true
}


variable "database_flags" {
  type = list(object({
    name  = string
    value = string
  }))

  default     = []
  description = "List of database flags to add."
}


variable "query_insights_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable Query Insights. Defaults to true"
}


variable "query_insights_config" {
  type = object({
    query_plans_per_minute  = number
    query_string_length     = number
    record_application_tags = bool
    record_client_address   = bool
  })

  default = {
    query_plans_per_minute  = 5
    query_string_length     = 1024
    record_application_tags = false
    record_client_address   = false
  }

  description = "Configuration for Query Insights"
}

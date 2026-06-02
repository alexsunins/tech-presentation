resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
}


resource "google_storage_bucket" "bucket" {
  name          = "${var.bucket_name}-${random_string.random_suffix.result}"
  project       = var.project_id
  location      = var.bucket_location
  force_destroy = var.force_destroy
  storage_class = var.storage_class
  labels        = var.labels

  uniform_bucket_level_access = var.enable_uniform_bucket_level_access

  versioning {
    enabled = var.enable_versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age            = lookup(lifecycle_rule.value.condition, "age", null)
        created_before = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state     = lookup(lifecycle_rule.value.condition, "with_state", null)
      }
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [var.retention_policy]
    content {
      is_locked        = lookup(retention_policy.value, "is_locked", false)
      retention_period = lookup(retention_policy.value, "retention_period", null)
    }
  }

  dynamic "logging" {
    for_each = var.logging == null ? [] : [var.logging]
    content {
      log_bucket        = lookup(logging.value, "log_bucket", null)
      log_object_prefix = lookup(logging.value, "log_object_prefix", null)
    }
  }

  dynamic "cors" {
    for_each = var.cors == null ? [] : [var.cors]
    content {
      origin          = lookup(cors.value, "origin", null)
      method          = lookup(cors.value, "method", null)
      response_header = lookup(cors.value, "response_header", null)
      max_age_seconds = lookup(cors.value, "max_age_seconds", null)
    }
  }
}

resource "google_monitoring_alert_policy" "low_disk_space_alert_policy" {
  project = var.project_id

  display_name = var.alert.display_name

  documentation {
    content = "Free space of the ${var.disk.name} disk on ${data.google_compute_instance.target_instance.name} is less than ${format("%d", 100 - var.alert.threshold_value)}% for over ${var.alert.retest_window_in_minutes} minute(s)."
  }

  combiner = "OR"
  conditions {
    display_name = "${var.instance.name} - Low Free Disk Space"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "${format("%d", var.alert.retest_window_in_minutes * 60)}s"
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${data.google_compute_instance.target_instance.instance_id}\" AND metric.type = \"agent.googleapis.com/disk/percent_used\" AND (metric.labels.state = \"used\" AND metric.labels.device = \"${var.disk.device}\")"
      threshold_value = var.alert.threshold_value
      trigger {
        count = "1"
      }
      aggregations {
        alignment_period   = "${format("%d", var.alert.rolling_window_in_minutes * 60)}s"
        per_series_aligner = "ALIGN_MEAN"
      } // rolling window
    }
  }

  alert_strategy {
    notification_channel_strategy {
      renotify_interval = "1800s"
      notification_channel_names = [
        data.google_monitoring_notification_channel.slack_channel.id
      ]
    }
  }

  notification_channels = [
    data.google_monitoring_notification_channel.slack_channel.id
  ]

  user_labels = var.labels
}

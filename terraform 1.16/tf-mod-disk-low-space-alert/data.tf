data "google_compute_instance" "target_instance" {
  name = var.instance.name
  zone = var.instance.zone
}


data "google_monitoring_notification_channel" "slack_channel" {
  display_name = var.slack_channel.display_name
}

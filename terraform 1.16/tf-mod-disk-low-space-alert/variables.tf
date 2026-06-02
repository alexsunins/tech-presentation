variable "project_id" {
  type        = string
  description = "The name of GCP Project where to deploy the alert"
}


variable "instance" {
  type = object({
    name = string
    zone = string
  })

  description = <<EOF
        name = The name of GCP instance to create the alert for
        zone = The zone of GCP instance to create the alert for
    EOF
}


variable "slack_channel" {
  type = object({
    display_name = string
  })

  description = "Display name of Slack channel to use as a notification channel"
}


variable "disk" {
  type = object({
    device = string
    name   = string
  })

  description = <<EOF
    Disk to monitor

    device - e.g. /dev/sdb
    name - partition name, e.g. /backups or Backups
  EOF
}


variable "alert" {
  type = object({
    display_name              = string
    retest_window_in_minutes  = number
    threshold_value           = number
    rolling_window_in_minutes = number
  })

  description = <<EOF
        Properties of the alert.

        display_name - the name as it appears in GCP Monitoring console
        retest_window_in_minutes - how often to retest the condition
        threshold_value - A value against which to compare the time series
        rolling_window_in_minutes - The alignment period for per-time series alignment. Must be at least 1 minute
    EOF
}


variable "labels" {
  type = map
  description =<<EOF
    Policy user labels allow you to add your own labels to alert policies for organization.
    The labels are included in the notification and incident details.
  EOF
  
  default = {
    severity = "warning"
  }
}
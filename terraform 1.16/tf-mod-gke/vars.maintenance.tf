# Variables related to the GKE cluster maintenance window

variable "daily_maintenance_window" {
  default = null

  type = object({
    start_time = string
  })

  description = <<EOD
    Configures the cluster to have a daily maintenance window.

    Time window specified for daily maintenance operations. Specify start_time in RFC3339 format "HH:MM”, where HH : [00-23] and MM : [00-59] GMT

    Example:
  
    daily_maintenance_window {
      start_time = "03:00"
    }
    
  EOD
}


variable "recurring_maintenance_window" {
  default = null

  type = object({
    start_time = string
    end_time   = string
    recurrence = string
  })

  description = <<EOD
    Configures the cluster to have a reccuring maintenance window.

    Specify start_time and end_time in RFC3339 "Zulu" date format.
    The start time's date is the initial date that the window starts, and the end time is used for calculating duration.
    Specify recurrence in RFC5545 RRULE format, to specify when this recurs.
    Note that GKE may accept other formats, but will return values in UTC, causing a permanent diff.

    Examples:

    recurring_maintenance_window = {
      start_time = "2019-08-01T02:00:00Z"
      end_time = "2019-08-01T06:00:00Z"
      recurrence = "FREQ=DAILY"
    }

    recurring_window {
      start_time = "2019-01-01T09:00:00Z"
      end_time = "2019-01-01T17:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
    }
  EOD
}


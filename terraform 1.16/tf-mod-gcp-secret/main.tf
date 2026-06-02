resource "google_secret_manager_secret" "gcp_secret" {
  provider  = google-beta

  secret_id = var.secret_name

  labels    = var.labels

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "gcp_secret_v1" {
  depends_on = [
    google_secret_manager_secret.gcp_secret
  ]

  provider    = google-beta

  secret      = google_secret_manager_secret.gcp_secret.id
  secret_data = var.secret_value
}

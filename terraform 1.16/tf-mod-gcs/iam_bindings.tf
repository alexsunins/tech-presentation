resource "google_storage_bucket_iam_binding" "storage_admins" {
  count   = length(var.storage_admins) == 0 ? 0 : 1
  bucket  = google_storage_bucket.bucket.name
  role    = "roles/storage.admin"
  members = var.storage_admins
}


resource "google_storage_bucket_iam_binding" "object_admins" {
  count   = length(var.object_admins) == 0 ? 0 : 1
  bucket  = google_storage_bucket.bucket.name
  role    = "roles/storage.objectAdmin"
  members = var.object_admins
}


resource "google_storage_bucket_iam_binding" "object_creators" {
  count   = length(var.object_creators) == 0 ? 0 : 1
  bucket  = google_storage_bucket.bucket.name
  role    = "roles/storage.objectCreator"
  members = var.object_creators
}


resource "google_storage_bucket_iam_binding" "object_viewers" {
  count   = length(var.object_viewers) == 0 ? 0 : 1
  bucket  = google_storage_bucket.bucket.name
  role    = "roles/storage.objectViewer"
  members = var.object_viewers
}


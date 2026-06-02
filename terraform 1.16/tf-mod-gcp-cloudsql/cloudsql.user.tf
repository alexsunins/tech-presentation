resource "google_sql_user" "default" {
  depends_on = [
    google_sql_database_instance.pgdb
  ]

  count = var.pg_user == null ? 0 : 1

  project  = var.project_id
  name     = var.pg_user.name
  password = var.pg_user.password
  instance = google_sql_database_instance.pgdb.name
}

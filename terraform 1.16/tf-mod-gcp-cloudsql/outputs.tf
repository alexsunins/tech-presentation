output "instance_name" {
  description = "CloudSQL instance name"
  value       = google_sql_database_instance.pgdb.name
}


output "instance_private_ip" {
  description = "The first private (PRIVATE) IPv4 address assigned to master instance."
  value       = google_sql_database_instance.pgdb.private_ip_address
}


output "instance_connection_name" {
  description = "Connection name of the instance to be used in connection strings"
  value       = google_sql_database_instance.pgdb.connection_name
}


output "instance_self_link" {
  description = "The URI of CloudSQL instance."
  value       = google_sql_database_instance.pgdb.self_link
}


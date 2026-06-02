output "internal_ip_addr" {
  value = google_compute_address.internal_ip.address
}


output "ssh_connection_string" {
  value = "gcloud compute ssh ${local.intance_name} --tunnel-through-iap --zone ${local.instance_zone} --project ${var.project}"
}

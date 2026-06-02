output "instance_ip" {
  value = var.external_static_ip_address.reserve_and_attach == false ? null : google_compute_address.ext_static_ip[0].address
}


output "service_account_id" {
  value = var.service_account_email == null ? module.gce_instance_sa.id : null
}


output "service_account_email" {
  value = var.service_account_email == null ? module.gce_instance_sa.email : var.service_account_email
}

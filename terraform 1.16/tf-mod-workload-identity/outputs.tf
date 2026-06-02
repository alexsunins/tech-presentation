output "ksa_name" {
  value = local.wi_ksa_name
}


output "gsa_name" {
  value = local.wi_gsa
}


output "gsa_email" {
  value = module.wi_gsa.email
}


output "gsa_id" {
  value = module.wi_gsa.id
}


output "wi_ksa_gcp_name" {
  value = local.wi_ksa_gcp_name
}

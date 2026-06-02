module "gce_instance_sa" {
  source = "<path_to_the_tf-mod-gcp-service-account_module_on_github>"

  service_account_name_prefix = "sa-gce"
  service_account_description = "Service Account for ${var.vm_name} VM Instance"
  project_id                  = var.project_id
  service_account_iam_roles   = var.service_account_iam_roles
}

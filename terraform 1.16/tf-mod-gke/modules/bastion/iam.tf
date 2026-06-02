## Create IAP SSH permissions for bastion host

resource "google_project_iam_member" "iap_tunnelResourceAccessor_role_mapping" {
  for_each = toset(var.ssh_allow)
  project  = var.project
  role     = "roles/iap.tunnelResourceAccessor"
  member   = "user:${each.value}"
}


## Create a custom role to allow to SSH
resource "google_project_iam_custom_role" "compute_ssh_allow" {
  role_id     = replace("custom_gke_${var.cluster_name}_${var.host_type}_compute_ssh_allow", "-", "_")
  title       = "Custom SSH Allow Role for ${var.cluster_name} ${var.host_type}"
  description = "Custom role to allow SSH to ${var.host_type} of ${var.cluster_name}"

  permissions = [
    "compute.instances.setMetadata"
  ]
}


resource "google_project_iam_member" "custom_compute_ssh_allow_role_mapping" {
  for_each = toset(var.ssh_allow)
  project  = var.project
  role     = google_project_iam_custom_role.compute_ssh_allow.id
  member   = "user:${each.value}"
}


# Add roles/iam.serviceAccountUser to allow users to impersonate SA of the bastion host
resource "google_service_account_iam_member" "iam_serviceaccount_user_role_mapping" {
  for_each           = toset(var.ssh_allow)
  service_account_id = module.instance_sa.id
  role               = "roles/iam.serviceAccountUser"
  member             = "user:${each.value}"
}


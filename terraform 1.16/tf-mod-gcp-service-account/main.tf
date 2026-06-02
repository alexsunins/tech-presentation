module "null_tester" {
  source = "./modules/null-tester"
  input  = var.service_account_name
}


resource "random_string" "sa_name_suffix" {
  count = module.null_tester.one_if_not_provided

  length  = var.service_account_name_suffix_length
  special = false
  upper   = false
}

locals {
  sa_name = (var.service_account_name == null) ? "${var.service_account_name_prefix}-${random_string.sa_name_suffix[0].result}" : var.service_account_name
}

resource "google_service_account" "sa" {
  account_id   = local.sa_name
  description  = var.service_account_description
  display_name = var.display_name == "" ? var.service_account_description : var.display_name
}


resource "google_service_account_iam_member" "non_project_level_sa_roles" {
  for_each = toset(var.non_project_level_iam_grants)

  service_account_id = google_service_account.sa.id
  role               = each.key
  member             = "serviceAccount:${google_service_account.sa.email}"
}


resource "google_project_iam_member" "project_level_sa_roles" {
  for_each = var.project_level_iam_grants == null ? toset([]) : toset(var.project_level_iam_grants.iam_roles)

  project = var.project_level_iam_grants == null ? null : var.project_level_iam_grants.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.sa.email}"
}

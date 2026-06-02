resource "google_project_iam_member" "role_mapping" {
  for_each = toset(var.roles)

  project  = var.project_id
  member   = var.member
  
  role     = each.value
}
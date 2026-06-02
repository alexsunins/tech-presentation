data "kubernetes_service" "web_service" {
  metadata {
    name      = var.web_service.name
    namespace = var.web_service.namespace
  }
}


resource "google_iap_web_backend_service_iam_member" "web_service_member_mapping" {
  for_each = {
    for idx, entity in distinct(var.user_access_list) :
    entity.email_address => entity
  }

  project             = var.project_id
  web_backend_service = local.web_backend_service_name
  role                = "roles/iap.httpsResourceAccessor"
  member              = "${each.value.entity}:${each.value.email_address}"
}

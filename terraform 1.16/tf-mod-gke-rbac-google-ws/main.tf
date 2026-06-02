resource "kubernetes_role" "role" {
  metadata {
    name      = "${var.name}-rbac-role"
    namespace = var.namespace
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      api_groups = rule.value.resource == "deployments" ? [ "apps", "extensions" ] : [""]
      resources = [ "${rule.value.resource}" ]
      verbs = rule.value.verbs
    }
  }
}


resource "kubernetes_role_binding" "role_binding" {
  metadata {
    name      = "${kubernetes_role.role.metadata[0].name}-binding-to-${split("@", var.ws_group_email_address)[0]}-ws-group"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.role.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = var.ws_group_email_address # <-- must be a member of gke-security-groups@yourdomain.com
    api_group = "rbac.authorization.k8s.io"
  }
}


locals {
  web_backend_service_name = jsondecode(data.kubernetes_service.web_service.metadata[0].annotations["cloud.google.com/neg-status"]).network_endpoint_groups["${var.port_name}"]
}

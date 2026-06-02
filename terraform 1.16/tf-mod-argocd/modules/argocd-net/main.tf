# if var.argocd_regional_ip is not null then we are deploying to a route-based GKE cluster

## GCP Regional address for `argocd-server` LoadBalancer service
resource "google_compute_address" "argocd_regional_ip_address" {
  count = var.argocd_regional_ip == null ? 0 : 1 // If var.argocd_regional_ip is provided then it is route-based GKE cluster

  name   = var.argocd_regional_ip.name
  region = var.argocd_regional_ip.region
}


resource "kubectl_manifest" "argocd_lb_service" {
  depends_on = [
    google_compute_address.argocd_regional_ip_address
  ]

  count = var.argocd_regional_ip == null ? 0 : 1

  yaml_body = templatefile("${path.module}/manifests/route_based/svc.yaml", {
    namespace_name     = var.argocd_namespace,
    regional_static_ip = google_compute_address.argocd_regional_ip_address[0].address
  })
}


# if var.argocd_regional_ip is null then we are deploying to a VPC-native GKE cluster
resource "kubectl_manifest" "vpc_native_service" {
  for_each = var.argocd_regional_ip == null ? toset(local.yaml_manifest_deployment_order.vpc_native) : []

  yaml_body = templatefile("${path.module}/manifests/vpc_native/${each.key}", {
    namespace_name       = var.argocd_namespace,
    manifest_fingerprint = sha1(file("${path.module}/manifests/vpc_native/${each.key}"))
  })
}

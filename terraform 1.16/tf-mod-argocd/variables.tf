variable "create_namespace" {
  type = bool

  description = <<EOL
    If set to:
      true  => will create namespace named after the value of local.argocd_namespace
      false => will assume that the namespace has already been created
  EOL

  default = false
}


variable "argocd_namespace" {
  description = "The name of k8s namespace where to deploy argocd. If set to `null` then defaults to `argocd`"
  type        = string
  default     = null
}


variable "expose_services" {
  description = "If true then will expose ArgoCD services via Ingress."
  type        = bool
  default     = false
}


variable "regional_ip_address_for_argocd_service" {
  type = object({
    name   = string
    region = string
  })

  default = null

  description = <<EOL
    If var.expose_services is set to true and if this variable is not null then we are deploying
    to a routes-based GKE cluster so we require to set ArgoCD service type to LoadBalancer therefore
    we need to create a regional external static IP address

    name   => the name of the IP address
    region => region of the IP address, MUST match GKE cluster region
  EOL
}


variable "app_version" {
  description = "The version of the application"
  type        = string
  default     = "v2.6.3"
}



variable "external_ip_address_for_ingress" {
  description = "The name of the external IP address for argocd LB"
  type = object({
    name = string
  })
}


variable "dns_name" {
  description = "FQDN for Google Managed Certificate"
  type        = string
}


variable "iap" {
  description = "If OAuth clientId and clientSecret are provided then the deployment will be secured with IAP"

  type = object({
    client_id     = string
    client_secret = string
  })

  default = null
}


variable "enable_google_sso" {
  type = object({
    service_account_key = string
    dex_oauth_client = object({
      client_id     = string
      client_secret = string
    })
    admin_user_email_address = string
  })

  default = null

  description = <<EOL
    If not `null` then login to ArgoCD will be handled by Google SSO.
    See https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/google/#openid-connect-plus-google-groups-using-dex

    service_account_key => contents of a key that is assigned to a service account, in base64 format.

    dex_oauth_client = {
      client_id     => ID of OAuth client for DEX
      client_secret => secret of OAuth client for DEX
    }

    admin_user_email_address => email address for a Google service account that is used to connect to the Google Directory API and pull information about your user's group membership

  EOL
}


variable "argocd_ingress_wait_time" {
  description = "How long to wait for k8s ingress to be created"
  type        = string
  default     = "180s"
}


## App config
variable "app_config" {
  description = <<EOT
    Various configurable settings related to apps deployed by ArgoCD.

    timeout_reconciliation => The controller polls Git every 3m by default. You can change this duration by changing this setting.

    allow_pod_exec => Since v2.4, Argo CD has a web-based terminal that allows you to get a shell inside a running pod just like you would with kubectl exec.
      It's basically SSH from your browser, full ANSI color support and all! However, for security this feature is disabled by default.

      This is a powerful privilege. It allows the user to run arbitrary code on any Pod managed by an Application for which they have the exec/create privilege.
      If the Pod mounts a ServiceAccount token (which is the default behavior of Kubernetes), then the user effectively has the same privileges as that ServiceAccount.
  EOT

  type = object({
    timeout_reconciliation = string
    allow_pod_exec         = string
  })

  default = {
    timeout_reconciliation = "180s"
    allow_pod_exec         = "false"
  }
}


variable "ssh_known_hosts" {
  description = <<EOT
    ArgoCD relies on SSH Known Hosts that are stored in rgocd-ssh-known-hosts-cm configmap.
    This variable allows to pass in a list of entries for a target VCS.
    If set to null then the stock manifest will be used.
  EOT

  type    = string
  default = null
}


variable "resource_tracking_method" {
  description = <<EOT
    Argo CD identifies resources it manages by setting the application instance label to
    the name of the managing Application on all resources that are managed (i.e. reconciled from Git).
    The default label used is the well-known label app.kubernetes.io/instance.

    To offer more flexible options for tracking resources Argo CD can be instructed to use the following methods for tracking:

    1. label (default) - Argo CD uses the app.kubernetes.io/instance label
    2. annotation+label - Argo CD uses the app.kubernetes.io/instance label but only for informational purposes.
      The annotation argocd.argoproj.io/tracking-id is used instead to track application resources
    3. annotation - Argo CD uses the argocd.argoproj.io/tracking-id annotation to track application resources

    Official docs - https://argo-cd.readthedocs.io/en/stable/user-guide/resource_tracking/#tracking-kubernetes-resources-by-label

  EOT

  type    = string
  default = "label"

  validation {
    condition     = contains(["label", "annotation+label", "annotation"], var.resource_tracking_method)
    error_message = "resource_tracking_method should be either label, annotation+label or annotation"
  }
}


variable "app_for_apps" {
  description = <<EOT
    As of version 2.5, Argo CD supports managing Application resources in namespaces
    other than the control plane's namespace (which is usually argocd).

    In order for an application to be managed and reconciled outside the Argo CD's control plane namespace
    `application.namespaces` configuration can be added to `argocd-cmd-params-cm` ConfigMap.

    This variable sets a value for `application.namespaces` key.
  EOT

  type = object({
    application_namespaces = list(string)
  })

  default = {
    application_namespaces = []
  }
}


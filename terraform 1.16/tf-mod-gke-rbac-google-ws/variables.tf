variable "name" {
    description = "The name of the RBAC role"
    type = string
}


variable "namespace" {
    description = "Namespace for the RBAC role"
    type = string
}


variable "rules" {
    description = "Rules for the RBAC role"
    type = list(object({
        resource = string
        verbs = list(string)
    }))
}


variable "ws_group_email_address" {
    description = "Google Workspace email address for the RBAC role binding. Must be a member of gke-security-groups@yourdomain.com"
    type = string
}

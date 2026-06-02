variable "project_id" {
  description = "The name of GCP project to apply the mapping in"
  type        = string
}


variable "member" {
  description = <<EOT
        Identity that will be granted the privilege in var.roles

        Can have one of the following values: user:{emailid}, serviceAccount:{emailid}, group:{emailid}, domain:{domain}
    EOT
  type        = string
}


variable "roles" {
  description = <<EOT
    A list of GCP roles that should be applied.

    ID of a role is expected, e.g. projects/my-awesome-project/roles/my_role
  EOT

  type        = list(string)
}

variable "manifest" {
  description = "Manifest file contents"
  type = object({
    yaml_body = string
  })
}

variable "wait_after_create" {
  description = "How much time to wait after the resource had been created"
  type        = string
  default     = null
}

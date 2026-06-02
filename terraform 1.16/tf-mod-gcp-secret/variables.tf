variable "secret_name" {
    description = "ID of the secret"
    type        = string  
}

variable "secret_value" {
    description = "The value of the secret"
    type        = string
    sensitive   = true
}

variable "labels" {
    description = "Labels to attach to the secret"
    type        = map(string)
}

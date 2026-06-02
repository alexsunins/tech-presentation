terraform {
  required_version = ">= 1.1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.9"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

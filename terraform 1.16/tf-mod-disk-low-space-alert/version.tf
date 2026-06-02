terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.9"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.5.0, < 4.6.0"
    }
  }
}

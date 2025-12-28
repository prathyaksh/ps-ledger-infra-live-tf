# dev/providers.tf
provider "google" {
  project = "project-de5f3b5f-5ab4-4a8e-974"
  region  = "asia-south1" # or your chosen region
}

provider "google-beta" {
  project = "project-de5f3b5f-5ab4-4a8e-974"
  region  = "asia-south1" # or your chosen region
}

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0.0" # Always pin your provider versions in production!
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.0.0"
    }
  }
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.33.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project = var.project
  region = var.region
  zone = var.zone
}


# enables desired apis for google project
resource "google_project_service" "services" {
  count = length(var.api)

  project = var.project
  service = var.api[count.index]
  disable_on_destroy = false
}


resource "time_sleep" "wait_project_init" {
  create_duration = "60s"

  depends_on = [google_project_service.services]
}
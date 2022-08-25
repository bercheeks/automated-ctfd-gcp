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
}


resource "google_app_engine_application" "app" {
  project     = var.project
  location_id = var.location
}


resource "google_app_engine_flexible_app_version" "flex_app" {
  version_id = "1"
  service    = "default"
  runtime    = "custom"

  deployment {
    container {
      image = "gcr.io/${var.project}/ctfd:1.0.0"
    }
  }

  liveness_check {
    path = "/setup"
  }

  readiness_check {
    path = "/setup"
    app_start_timeout = "1000s"
  }

  automatic_scaling {
    cool_down_period    = "120s"
    max_total_instances = 2
    min_total_instances = 1
    cpu_utilization {
      target_utilization = 0.7
    }
  }

  resources {
    cpu       = 2
    memory_gb = 4
    disk_gb = 10
  }
  network {
    name = "default"
  }

  depends_on = [google_app_engine_application.app]
}
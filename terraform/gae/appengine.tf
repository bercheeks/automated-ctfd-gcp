terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.33.0"
    }
  }
}


locals {
  env_variables = {
      "DATABASE_URL" = "mysql+pymysql://root:<password>@<internal_ip>/ctfd"
      "REDIS_URL" = "redis://<internal_ip>:6379"
      "UPLOAD_PROVIDER" = "s3"
      "AWS_ACCESS_KEY_ID" = "[redacted]" # need from settings
      "AWS_SECRET_ACCESS_KEY" = "[redacted]" # need from settings
      "AWS_S3_BUCKET" = google_storage_bucket.ctfd_upload_bucket.name
      "AWS_S3_ENDPOINT_URL" = "https://storage.googleapis.com"
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


resource "google_project_iam_member" "gae_api" {
  depends_on = [google_app_engine_application.app]
  project    = var.project
  role       = "roles/compute.networkUser"
  member     = format("serviceAccount:%s@appspot.gserviceaccount.com", var.project)
}


resource "google_project_iam_member" "gae_gcs" {
  depends_on = [google_app_engine_application.app]
  project    = var.project
  role       = "roles/storage.objectViewer"
  member     = format("serviceAccount:%s@appspot.gserviceaccount.com", var.project)
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

  env_variables = local.env_variables

  # change after setup to '/'
  liveness_check {
    path = "/setup"
  }

  # change after setup to '/'
  readiness_check {
    path = "/setup"
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
    name = "ctf-private"
    subnetwork = "ctfd-subnet"
  }

  depends_on = [
    google_app_engine_application.app,
    google_project_iam_member.gae_gcs,
    google_project_iam_member.gae_api
  ]
}


resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.ctfd_upload_bucket.name
  role   = "READER"
  entity = "allUsers"
}


resource "google_storage_bucket" "ctfd_upload_bucket" {
  name          = "upload_challenge_files_bucket"
  location      = var.location
}
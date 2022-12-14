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
      "REVERSE_PROXY" = "2,1,0,0,0" # for cloudflare proxy and app engine NEG load balancer
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


  liveness_check {
    path = "/themes/core/static/css/main.dev.css"
  }


  readiness_check {
    path = "/themes/core/static/css/main.dev.css"
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


resource "google_compute_global_address" "default" {
  project      = var.project
  name         = "ctfd-lb-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}


resource "google_compute_managed_ssl_certificate" "ssl" {
  name = "ssl-cert"

  managed {
    domains = ["[redacted]"] # enter your domain name here
  }
}


resource "google_compute_region_network_endpoint_group" "appengine_neg" {
  name                  = "appengine-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.location
  app_engine {
    service = google_app_engine_flexible_app_version.flex_app.service
    version = google_app_engine_flexible_app_version.flex_app.version_id
  }
}


resource "google_compute_backend_service" "default" {
  name = "backend-service"
  session_affinity = "CLIENT_IP"
  enable_cdn = true
  backend {
    description = "backend"
    group = google_compute_region_network_endpoint_group.appengine_neg.id
  }
}


resource "google_compute_target_https_proxy" "default" {
  name             = "ctfd-proxy"
  url_map = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl.id]
}


resource "google_compute_url_map" "default" {
  name        = "ctfd-https-lb"
  default_service = google_compute_backend_service.default.id
}


resource "google_compute_global_forwarding_rule" "default" {
  name = "ssl-proxy-xlb-forwarding-rule"
  ip_protocol = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range = "443"
  target = google_compute_target_https_proxy.default.id
  ip_address = google_compute_global_address.default.id
}

# uncomment if http redirect isnt working
# resource "google_compute_url_map" "http-redirect" {
#   name = "http-redirect"

#   default_url_redirect {
#     redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"  // 301 redirect
#     strip_query            = false
#     https_redirect         = true  // this is the magic
#   }
# }

# resource "google_compute_target_http_proxy" "http-redirect" {
#   name    = "http-redirect"
#   url_map = google_compute_url_map.http-redirect.self_link
# }

# resource "google_compute_global_forwarding_rule" "http-redirect" {
#   name       = "http-redirect"
#   target     = google_compute_target_http_proxy.http-redirect.self_link
#   ip_address = google_compute_global_address.default.address
#   port_range = "80"
# }
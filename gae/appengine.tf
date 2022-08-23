resource "google_app_engine_application" "app" {
  project     = var.project
  location_id = var.location
}


resource "google_app_engine_flexible_app_version" "myapp_v1" {
  version_id = "v1"
  project    = var.project
  service    = "default"
  runtime    = "custom"

  deployment {
    container {
      image = "gcr.io/cloudrun/hello"
    }
  }

  liveness_check {
    path = "/"
  }

  readiness_check {
    path = "/"
  }
  
  automatic_scaling {
    cool_down_period = "120s"
    cpu_utilization {
      target_utilization = 0.5
    }
  }

  noop_on_destroy = false
  delete_service_on_destroy = true

  depends_on = [google_app_engine_application.app]
}
resource "google_compute_instance" "test-instance" {
  name                      = "test"
  machine_type              = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.internal.name

    access_config {
    }
  }
}
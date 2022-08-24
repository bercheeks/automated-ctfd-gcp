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
  region  = var.region
  zone    = var.zone
}


resource "google_compute_network" "vpc" {
  name = "ctf-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "internal" {
  name = "test-subnet"
  ip_cidr_range = "10.10.10.0/24"
  region = var.region
  network = google_compute_network.vpc.id
}

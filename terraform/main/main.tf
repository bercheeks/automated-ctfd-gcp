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


resource "google_compute_network" "private_network" {
  name = "ctf-private"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "internal" {
  name = "ctfd-subnet"
  ip_cidr_range = "10.10.10.0/24"
  region = var.region
  network = google_compute_network.private_network.id
}


resource "google_compute_global_address" "private_ip_address" {

  name = "private-ip-address"
  purpose = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network = google_compute_network.private_network.id
}


resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}


resource "random_id" "db_name_suffix" {
  byte_length = 4
}


resource "google_sql_database_instance" "instance" {
  name             = "private-instance2-${random_id.db_name_suffix.hex}"
  region           = var.region
  database_version = "MYSQL_8_0"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
    }
  }
}

resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  password = var.db_password
}
output "load_balancing_ip" {
  description = "Address of load balancer"
  value       = google_compute_global_address.default.address
}
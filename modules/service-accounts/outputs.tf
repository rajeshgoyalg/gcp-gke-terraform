output "email" {
  description = "Service account email"
  value       = google_service_account.workload_identity.email
}

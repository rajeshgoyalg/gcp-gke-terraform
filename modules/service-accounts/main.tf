# Service Accounts Module - Creates a GCP service account for GKE workloads
resource "google_service_account" "workload_identity" {
  account_id   = var.account_id
  display_name = var.display_name
}

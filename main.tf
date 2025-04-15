# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "gke-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "gke-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# GKE Cluster (Standard, with Workload Identity)
resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
#   remove_default_node_pool = true # Make sure this is uncommented
  initial_node_count       = 1    # Add this line
  enable_autopilot         = false
  network                  = google_compute_network.vpc.id
  subnetwork               = google_compute_subnetwork.subnet.name

  deletion_protection      = false

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {} # Enable VPC-native IPs
}

# Custom Node Pool (Keep this as is)
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 30
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Ensure this depends on the cluster being created
  # Although often implicit, explicit dependency can sometimes help clarity or ordering issues
  # depends_on = [google_container_cluster.primary] # Usually not needed here, Terraform infers it
}
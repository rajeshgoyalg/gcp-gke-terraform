# Root Terraform configuration for GKE on GCP (modularized)

# VPC Module
module "vpc" {
  source      = "./modules/vpc"
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
  region      = var.region
}

# Service Account Module (for Workload Identity)
module "service_account" {
  source       = "./modules/service-accounts"
  account_id   = var.workload_sa_id
  display_name = var.workload_sa_display_name
}

# GKE Module
module "gke" {
  source         = "./modules/gke"
  project_id     = var.project_id
  region         = var.region
  cluster_name   = var.cluster_name
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.subnet_id
  node_pool_name = var.node_pool_name
  node_count     = var.node_count
  machine_type   = var.machine_type
  disk_size_gb   = var.disk_size_gb
}

# Outputs are defined in outputs.tf
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "demo-gke-cluster"
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "gke-vpc"
}

variable "subnet_name" {
  description = "Name for the subnet"
  type        = string
  default     = "gke-subnet"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "workload_sa_id" {
  description = "Service account ID for GKE workload identity"
  type        = string
  default     = "gke-workload-sa"
}

variable "workload_sa_display_name" {
  description = "Display name for the GKE workload identity service account"
  type        = string
  default     = "GKE Workload Identity SA"
}

variable "node_pool_name" {
  description = "Name for the node pool"
  type        = string
  default     = "primary-node-pool"
}

variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "disk_size_gb" {
  description = "Disk size in GB for GKE nodes"
  type        = number
  default     = 30
}
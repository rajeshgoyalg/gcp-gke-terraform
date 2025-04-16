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

variable "region" {
  description = "GCP region"
  type        = string
}

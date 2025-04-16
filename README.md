# GCP GKE Terraform Modular Infrastructure

## Project Overview
This project provisions a production-ready Google Kubernetes Engine (GKE) cluster and its dependencies on Google Cloud Platform (GCP) using Terraform. The infrastructure is organized into reusable modules for VPC networking, service accounts/IAM, and GKE cluster creation. The modular structure enables secure, scalable, and maintainable cloud deployments.

## Architecture
```
+---------------------+
|      VPC Module     |
|  (Custom Network)   |
+---------------------+
           |
           v
+---------------------+
|   Subnet (VPC)      |
+---------------------+
           |
           v
+---------------------+     +---------------------------+
|   Service Account   |<--->|     GKE Cluster Module    |
|    (IAM/Workload)   |     | (Cluster & Node Pool)     |
+---------------------+     +---------------------------+
```
- **VPC Module**: Provisions a custom network and subnet for the GKE cluster.
- **Service Accounts Module**: Creates a GCP service account for GKE Workload Identity.
- **GKE Module**: Provisions a GKE cluster and node pool, configured for Workload Identity and VPC-native networking.

## Modules
### 1. VPC Module (`modules/vpc`)
- Creates a custom VPC network and subnet for GKE.
- Outputs: VPC ID, Subnet ID.

### 2. Service Accounts Module (`modules/service-accounts`)
- Provisions a GCP service account for Kubernetes workloads (Workload Identity).
- Outputs: Service account email.

### 3. GKE Module (`modules/gke`)
- Provisions a GKE cluster (standard, not Autopilot) and a custom node pool.
- Configured for Workload Identity and VPC-native IPs.
- Outputs: Cluster name, endpoint, node pool name.

## Prerequisites
- [Terraform](https://www.terraform.io/) >= 1.4.0
- [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- A GCP project with billing enabled
- Service account credentials (see below)

### Enable Required GCP APIs
```
gcloud services enable \
  container.googleapis.com \
  compute.googleapis.com \
  iam.googleapis.com \
  cloudresourcemanager.googleapis.com
```

## Authentication and Secure Credentials
- Create a dedicated GCP service account with sufficient IAM permissions for GKE, networking, and IAM.
- Download the service account key as `terraform-key.json` and **never commit this file to version control**.
- Recommended: Use environment variables or a secret manager for credentials in CI/CD.

```
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/terraform-key.json"
```

## Usage
1. **Clone the repository**
2. **Configure variables**: Edit `terraform.tfvars` or override variables via CLI.
3. **Initialize Terraform**
   ```sh
   terraform init
   ```
4. **Review the execution plan**
   ```sh
   terraform plan
   ```
5. **Apply the configuration**
   ```sh
   terraform apply
   ```
6. **Configure kubectl**
   ```sh
   # Output command from Terraform
   gcloud container clusters get-credentials <cluster_name> --region <region> --project <project_id>
   ```

## Variables Reference (from `variables.tf`)
| Name                     | Description                                         | Default               |
|--------------------------|-----------------------------------------------------|-----------------------|
| project_id               | GCP project ID                                      | -                     |
| region                   | GCP region                                          | -                     |
| cluster_name             | GKE cluster name                                    | demo-gke-cluster      |
| vpc_name                 | Name for the VPC                                    | gke-vpc               |
| subnet_name              | Name for the subnet                                 | gke-subnet            |
| subnet_cidr              | CIDR block for the subnet                           | 10.0.0.0/16           |
| workload_sa_id           | Service account ID for workload identity            | gke-workload-sa       |
| workload_sa_display_name | Display name for the workload identity SA           | GKE Workload Identity SA |
| node_pool_name           | Name for the node pool                              | primary-node-pool     |
| node_count               | Number of nodes in the node pool                    | 1                     |
| machine_type             | Machine type for GKE nodes                          | e2-medium             |
| disk_size_gb             | Disk size in GB for GKE nodes                       | 30                    |

## Outputs
- **kubeconfig_command**: Command to configure `kubectl` for the new GKE cluster.
- **module.gke.cluster_name**: GKE cluster name.
- **module.gke.endpoint**: GKE cluster endpoint.
- **module.gke.node_pool_name**: Node pool name.
- **module.service_account.email**: Service account email.
- **module.vpc.vpc_id**: VPC ID.
- **module.vpc.subnet_id**: Subnet ID.

## State Management
- Terraform state is stored locally in `terraform.tfstate` by default. For team use, configure a remote backend (e.g., GCS bucket with state locking).
- **Never commit state files or credentials to version control.**

## Security Practices
- **Do not commit `terraform-key.json`, `.tfstate`, or `.tfvars` with secrets to git.**
- Use least-privilege IAM for service accounts.
- Rotate credentials regularly.
- Use remote backends with state locking and encryption for production.
- Audit and restrict network access to the GKE cluster.

## Troubleshooting
- **API errors**: Ensure all required GCP APIs are enabled.
- **Permission denied**: Check IAM roles and service account permissions.
- **kubectl not authorized**: Use the output `kubeconfig_command` to authenticate.
- **Resource conflicts**: Destroy old resources or use unique names.

## License
MIT License. See [LICENSE](LICENSE) for details.

## Contributions
Contributions and improvements are welcome! Please open issues or pull requests.

# Google Cloud GKE Cluster

## Introduction

Create a standardized GKE cluster that is good enough for a bunch of general purpose work.

## Usage

The most basic way to create a GKE cluster using the Terraform [`google_container_cluster`](https://www.terraform.io/docs/providers/google/r/container_cluster.html) resource with worker nodes in the default pool.

```
provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-a"
  alias  = "google_beta"
}

locals {
  container_cluster_name = "k8s-1"
  container_cluster_zone = "us-central1-a"
  k8s_version            = "1.14.10-gke.22"
  cluster_type           = "zonal"
  project_id             = "a-project-id"
}

module "gke" {
  source       = "github.com/infrastructure-as-code/terraform-google-gke-cluster"
  name         = local.container_cluster_name
  location     = local.container_cluster_zone
  cluster_type = local.cluster_type
  k8s_version  = local.k8s_version
  project_id   = local.project_id

  remove_default_node_pool = false
  default_node_pool = {
      machine_type = "e2-standard-2"
      disk_type    = "pd-standard"
      disk_size_gb = 100
      preemptible  = true
      count        = 3
  }

  providers = {
    google = google-beta.google_beta
  }
}

```

Setting the `remove_default_node_pool` variable to `true` will remove the default node pool, and create additional pools of workers as defined by the `node_pools` variable.

```
provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-a"
  alias  = "google_beta"
}

locals {
  container_cluster_name = "k8s-1"
  container_cluster_zone = "us-central1-a"
  k8s_version            = "1.14.10-gke.22"
  cluster_type           = "zonal"
  project_id             = "a-project-id"
}

module "gke" {
  source       = "github.com/infrastructure-as-code/terraform-google-gke-cluster"
  name         = local.container_cluster_name
  location     = local.container_cluster_zone
  cluster_type = local.cluster_type
  k8s_version  = local.k8s_version
  project_id   = local.project_id

  remove_default_node_pool = true
  node_pools = [
    {
      name         = "main-pool"
      machine_type = "e2-standard-2"
      disk_type    = "pd-standard"
      disk_size_gb = 100
      preemptible  = true
      count        = 3
    },
  ]

  providers = {
    google = google-beta.google_beta
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cluster\_type | regional or zonal cluster | `string` | n/a | yes |
| default\_node\_pool | Nodes in the default node pool | <pre>object({<br>    machine_type = string<br>    disk_type    = string<br>    disk_size_gb = number<br>    preemptible  = bool<br>    count        = number<br>  })</pre> | <pre>{<br>  "count": 3,<br>  "disk_size_gb": 20,<br>  "disk_type": "pd-standard",<br>  "machine_type": "f1-micro",<br>  "preemptible": false<br>}</pre> | no |
| k8s\_version | Kubernetes version | `string` | n/a | yes |
| location | Cluster region or zone | `string` | n/a | yes |
| name | Name of cluster | `string` | n/a | yes |
| node\_pools | Type of nodes and number for each | <pre>list(object({<br>    name         = string<br>    machine_type = string<br>    disk_type    = string<br>    disk_size_gb = number<br>    preemptible  = bool<br>    count        = number<br>  }))</pre> | `[]` | no |
| project\_id | Project ID | `string` | n/a | yes |
| remove\_default\_node\_pool | Delete the default node pool after the cluster is created | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | Kubernetes cluster CA certificate |
| configure\_kubectl | Command to configure credentials for kubectl |
| endpoint | Kubernetes endpoint |


## References

1. https://www.terraform.io/docs/providers/google/r/container_cluster.html

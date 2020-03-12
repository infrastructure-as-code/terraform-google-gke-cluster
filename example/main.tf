provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-c"
  alias  = "google_beta"
}

module "k8s" {
  source       = "./.."
  name         = "gke-cluster-example"
  location     = "us-central1-a"
  cluster_type = "zonal"
  k8s_version  = "1.14.10-gke.22"
  project_id   = "forever-project"

  remove_default_node_pool = false
  default_node_pool = {
    machine_type = "f1-micro"
    disk_type    = "pd-standard"
    disk_size_gb = 100
    preemptible  = true
    count        = 3
  }

  providers = {
    google = google-beta.google_beta
  }
}

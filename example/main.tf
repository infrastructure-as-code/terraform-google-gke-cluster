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
  k8s_version  = "1.15.9-gke.24"
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

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "gcloud beta container clusters get-credentials gke-cluster-1 --zone us-central1-a --project forever-project"
  }
  depends_on = [
    module.k8s
  ]
}

output "configure_kubectl" {
  value = module.k8s.configure_kubectl
}

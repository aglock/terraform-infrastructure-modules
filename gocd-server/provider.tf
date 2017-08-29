data "terraform_remote_state" "gke" {
  backend = "gcs"
  config {
    bucket = "${var.google_project}"
    path = "europe-west1/prod/gke/terraform.tfstate"    
    project="${var.google_project}" 
    credentials = "${var.google_keyfile}"
  }
}

provider "kubernetes" {
  host = "${data.terraform_remote_state.gke.endpoint}"
  username = "${data.terraform_remote_state.gke.username}"
  password = "${data.terraform_remote_state.gke.password}"
  client_certificate = "${data.terraform_remote_state.gke.client_certificate}"
  client_key = "${data.terraform_remote_state.gke.client_key}"
  cluster_ca_certificate = "${data.terraform_remote_state.gke.ca_certificate}"
}

provider "google" {
  project     = "${var.google_project}"
  region      = "${var.google_region}"
  credentials = "${file("${var.google_keyfile}")}"
}

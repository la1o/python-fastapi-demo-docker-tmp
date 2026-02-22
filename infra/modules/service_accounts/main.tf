variable "project_id" {}
variable "app_name" {}

resource "google_service_account" "runtime" {
  account_id   = "${var.app_name}-runtime"
  display_name = "Cloud Run Runtime SA"
  project      = var.project_id
}

resource "google_service_account" "deployer" {
  account_id   = "${var.app_name}-deployer"
  display_name = "GitHub Deployer SA"
  project      = var.project_id
}

# Permiso para desplegar Cloud Run
resource "google_project_iam_member" "deployer_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}

# Permiso para usar el runtime SA
resource "google_service_account_iam_member" "deployer_runtime_user" {
  service_account_id = google_service_account.runtime.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.deployer.email}"
}

output "runtime_sa_email" {
  value = google_service_account.runtime.email
}

output "deployer_sa_email" {
  value = google_service_account.deployer.email
}

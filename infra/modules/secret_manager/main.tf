variable "project_id" {}
variable "secret_name" {}
variable "runtime_sa_email" {}
variable "deployer_sa_email" {}

resource "google_secret_manager_secret" "secret" {
  project   = var.project_id
  secret_id = var.secret_name
  secret_data = "init"

  replication {
    auto {}
  }
}

# Runtime solo puede LEER
resource "google_secret_manager_secret_iam_member" "runtime_accessor" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.secret.secret_id

  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${var.runtime_sa_email}"
}

# Deployer puede AGREGAR versiones
resource "google_secret_manager_secret_iam_member" "deployer_version_adder" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.secret.secret_id

  role   = "roles/secretmanager.secretVersionAdder"
  member = "serviceAccount:${var.deployer_sa_email}"
}

output "secret_name" {
  value = google_secret_manager_secret.secret.secret_id
}

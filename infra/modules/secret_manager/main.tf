variable "project_id" {}
variable "secret_name" {}
variable "runtime_sa_email" {}

resource "google_secret_manager_secret" "secret" {
  project   = var.project_id
  secret_id = var.secret_name

  replication {
    auto {}
  }
}

# Permiso mínimo: solo este secreto
resource "google_secret_manager_secret_iam_member" "runtime_accessor" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.secret.secret_id

  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${var.runtime_sa_email}"
}

output "secret_name" {
  value = google_secret_manager_secret.secret.secret_id
}

variable "project_id" {}
variable "secret_name" {}

resource "google_secret_manager_secret" "secret" {
  project   = var.project_id
  secret_id = var.secret_name

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "initial" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = "init"
}

output "secret_name" {
  value = google_secret_manager_secret.secret.secret_id
}

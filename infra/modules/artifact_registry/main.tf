variable "project_id" {}
variable "region" {}
variable "repository_name" {}
variable "deployer_sa_email" {}

resource "google_artifact_registry_repository" "repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_name
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "writer" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.repo.name

  role   = "roles/artifactregistry.writer"
  member = "serviceAccount:${var.deployer_sa_email}"
}

variable "project_id" {}
variable "service_name" {}
variable "region" {}
variable "runtime_sa_email" {}
variable "image" {}
variable "secret_name" {}
variable "deletion_protection" {
  type    = bool
  default = true
}

resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  deletion_protection = var.deletion_protection

  template {
    service_account = var.runtime_sa_email

    containers {
      image = var.image

      env {
        name = "APP_VERSION"

        value_source {
          secret_key_ref {
            secret  = var.secret_name
            version = "latest"
          }
        }
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

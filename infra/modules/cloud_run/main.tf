variable "project_id" {}
variable "region" {}
variable "service_name" {}
variable "image" {}
variable "runtime_sa_email" {}
variable "secret_name" {}

resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  deletion_protection = false

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

resource "google_cloud_run_service_iam_member" "public" {
  location = var.region
  project  = var.project_id
  service  = google_cloud_run_v2_service.service.name

  role   = "roles/run.invoker"
  member = "allUsers"
}

output "service_url" {
  value = google_cloud_run_v2_service.service.uri
}

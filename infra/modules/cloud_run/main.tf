variable "project_id" {}
variable "region" {}
variable "service_name" {}
variable "image" {}
variable "runtime_sa_email" {}
variable "secret_name" {}
variable "docker_database_url" {}

resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  deletion_protection = false

  template {
    service_account = var.runtime_sa_email

    containers {
      image = var.image

      ports {
        container_port = 8000
      }

      startup_probe {
        initial_delay_seconds = 10
        timeout_seconds = 5
        period_seconds = 240
        failure_threshold = 5
        tcp_socket {
          port = 8000
        }
      }

      liveness_probe {
        http_get {
          path = "/health"
        }
      }

      resources {
        cpu_idle = true
        limits = {
          cpu    = "1"
          memory = "128Mi"
        }
      }

      env {
        name  = "DOCKER_DATABASE_URL"
        value = var.docker_database_url
      }

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

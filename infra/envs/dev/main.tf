provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  service_name = "${var.app_name}-dev"
}

module "artifact_registry" {
  source          = "../../modules/artifact_registry"
  project_id      = var.project_id
  region          = var.region
  repository_name = local.service_name
}

module "service_accounts" {
  source     = "../../modules/service_accounts"
  project_id = var.project_id
  name       = local.service_name
}

module "secret_manager" {
  source      = "../../modules/secret_manager"
  project_id  = var.project_id
  secret_name = "${local.service_name}-version"
}

module "cloud_run" {
  source           = "../../modules/cloud_run"
  project_id       = var.project_id
  service_name     = local.service_name
  region           = var.region
  runtime_sa_email = module.service_accounts.runtime_email
  image            = var.image
  secret_name      = module.secret_manager.secret_name
  deletion_protection = false
}

module "github_wif" {
  source            = "../../modules/github_wif"
  project_id        = var.project_id
  project_number    = var.project_number
  github_repository = var.github_repository
  deployer_sa_email = module.service_accounts.deployer_email
}

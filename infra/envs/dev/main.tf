provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {}
variable "project_number" {}
variable "region" {}
variable "app_name" {}
variable "github_repository" {}
variable "image" {}
variable "docker_database_url" {}
variable "environment" {}

module "service_accounts" {
  source     = "../../modules/service_accounts"
  project_id = var.project_id
  app_name   = "${var.app_name}-${var.environment}"
}

module "artifact_registry" {
  source             = "../../modules/artifact_registry"
  project_id         = var.project_id
  region             = var.region
  repository_name    = "${var.app_name}-${var.environment}"
  deployer_sa_email  = module.service_accounts.deployer_sa_email
}

module "secret_manager" {
  source           = "../../modules/secret_manager"
  project_id       = var.project_id
  secret_name      = "${var.app_name}-${var.environment}-version"
  runtime_sa_email = module.service_accounts.runtime_sa_email
}

module "cloud_run" {
  source              = "../../modules/cloud_run"
  project_id          = var.project_id
  region              = var.region
  service_name        = "${var.app_name}-${var.environment}"
  image               = var.image
  runtime_sa_email    = module.service_accounts.runtime_sa_email
  secret_name         = "${var.app_name}-${var.environment}-version"
  docker_database_url = var.docker_database_url
}

module "github_wif" {
  source            = "../../modules/github_wif"
  project_id        = var.project_id
  project_number    = var.project_number
  github_repository = var.github_repository
  deployer_sa_email = module.service_accounts.deployer_sa_email
}

locals {
  // The list of GCP APIs to enable
  admin_project_apis = [
    "iam.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddeploy.googleapis.com",
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
  ]
}

resource "google_project" "admin_project" {
  name            = "${var.proj_name_prefix} admin"
  project_id      = "${var.proj_id_prefix}-admin"
  folder_id       = var.folder_id
  billing_account = var.billing_account
}

// Enable GCP APIs that we use
resource "google_project_service" "admin_enabled_services" {
  for_each = toset(local.admin_project_apis)
  service  = each.value
  project  = google_project.admin_project.project_id
}

resource "google_service_account" "deployer_service_account" {
  account_id   = "cloud-deploy-deployer"
  display_name = "Cloud Deploy deployer"
  project      = google_project.admin_project.project_id
}

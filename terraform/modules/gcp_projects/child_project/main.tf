locals {
    child_project_apis = [
        "iam.googleapis.com", 
        "run.googleapis.com", 
        "compute.googleapis.com",
    ]
}

resource "google_project" "project" {
    name = "${var.proj_name_prefix} ${var.env}"
    project_id = "${var.proj_id_prefix}-${var.env}"
    folder_id = var.folder_id
    billing_account = var.billing_account
}

resource "google_project_service" "child_enabled_services" {
    for_each = toset(local.child_project_apis)
    service = each.value
    project = google_project.project.project_id
}

resource "google_service_account" "deployer_service_account" {
    account_id = "cloud-deploy-deployer"
    display_name = "Cloud Deploy deployer"
    project = google_project.project.project_id
}
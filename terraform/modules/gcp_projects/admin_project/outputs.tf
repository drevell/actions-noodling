output "project_id" {
  value = google_project.admin_project.project_id
}

output "deployer_service_account_id" {
  value = google_service_account.deployer_service_account.account_id
}

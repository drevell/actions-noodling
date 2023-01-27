provider "google" {
  region = var.region
}

module "admin_project" {
  source           = "./modules/gcp_projects/admin_project"
  folder_id        = var.folder_id
  proj_name_prefix = var.proj_name_prefix
  proj_id_prefix   = var.proj_id_prefix
  billing_account  = var.billing_account
}

locals {
  environments = {
    "dev" : {
      cloud_run_region = "us-central1"
    },
    "staging" : {
      cloud_run_region = "us-west1"
    },
    "prod" : {
      cloud_run_region = "us-east1"
    }
  }
}

module "child_projects" {
  for_each         = local.environments
  env              = each.key
  source           = "./modules/gcp_projects/child_project"
  folder_id        = var.folder_id
  proj_name_prefix = var.proj_name_prefix
  proj_id_prefix   = var.proj_id_prefix
  billing_account  = var.billing_account
}

# module "dev_project" {
#   source           = "./modules/gcp_projects/child_project"
#   folder_id        = var.folder_id
#   proj_name_prefix = var.proj_name_prefix
#   proj_id_prefix   = var.proj_id_prefix
#   env              = "dev"
#   billing_account  = var.billing_account
# }

# module "staging_project" {
#   source           = "./modules/gcp_projects/child_project"
#   folder_id        = var.folder_id
#   proj_name_prefix = var.proj_name_prefix
#   proj_id_prefix   = var.proj_id_prefix
#   env              = "staging"
#   billing_account  = var.billing_account
# }

# module "prod_project" {
#   source           = "./modules/gcp_projects/child_project"
#   folder_id        = var.folder_id
#   proj_name_prefix = var.proj_name_prefix
#   proj_id_prefix   = var.proj_id_prefix
#   env              = "prod"
#   billing_account  = var.billing_account
# }

// Create Cloud Deploy pipeline

resource "google_clouddeploy_target" "cloudrun_targets" {
  for_each = local.environments

  location = var.region
  name     = "hello-world-${each.key}-cloudrun-target"

  description = "Hello World Cloud Run target for ${each.key} env"

  execution_configs {
      usages          = ["RENDER"]
      service_account = module.admin_project.deployer_service_account_id
    }
  execution_configs {
      usages          = ["DEPLOY", "VERIFY"]
      service_account = module.child_projects[each.key].deployer_service_account_id
    }

  project          = module.admin_project.project_id
  require_approval = false

  run {
    location = "projects/${module.child_projects[each.key].project_id}/locations/${each.value.cloud_run_region}"
  }
  provider = google-beta
}

resource ""

// Set up IAM roles

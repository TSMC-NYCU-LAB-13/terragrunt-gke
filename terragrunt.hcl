# data "google_client_config" "default" {}

locals {
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  region = local.region_vars.locals.region

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "git::git@github.com:terraform-google-modules/terraform-google-kubernetes-engine.git//modules/beta-public-cluster"
}

# Generate provider block
# generate "provider" {
#   path      = "provider.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "kubernetes" {
#   host                   = "https://${module.gke.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
# }
# EOF
# }

# terragrunt {
#   remote_state {
#     backend = "gcs"
#     config {
#       bucket  = "gke-blog-prod-remote-state"
#       prefix  = path_relative_to_include()
#       region  = "europe-west1"
#       project = "gke-blog-prod"
#     }
#   }
# }

terraform {
  source = "${local.base_source_url}?ref=v21.1.0"
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals,
  {
    project_id             = "nycu-lab-13"
    create_service_account = false
    node_pools = [
      {
        name               = "default-node-pool"
        machine_type       = "e2-medium"
        min_count          = 1
        max_count          = 100
        local_ssd_count    = 0
        image_type         = "UBUNTU_CONTAINERD"
        enable_gcfs        = false
        auto_repair        = true
        auto_upgrade       = true
        preemptible        = false
        initial_node_count = 5
      },
    ]

  }
)

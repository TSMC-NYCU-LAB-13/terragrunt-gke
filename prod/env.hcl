# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment       = "prod"
  name              = "prod-lab-13"
  network           = "default"
  subnetwork        = "default"
  ip_range_pods     = "prod-asia-east1-01-gke-01-pods"
  ip_range_services = "prod-asia-east1-01-gke-01-services"
}

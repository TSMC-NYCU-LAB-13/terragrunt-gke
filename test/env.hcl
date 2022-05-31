# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment       = "test"
  name              = "test-lab-13"
  network           = "test-vpc-13"
  subnetwork        = "test-asia-east1-01"
  ip_range_pods     = "test-asia-east1-01-gke-01-pods"
  ip_range_services = "prod-asia-east1-01-gke-01-services"
}

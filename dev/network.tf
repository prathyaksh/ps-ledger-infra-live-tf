module "vpc_dev" {
  # For now, we use a relative path. Later, we can switch to Git Tags.
  source = "../../ps-ledger-infra-modules-tf/modules/vpc"

  network_name = var.dev_vpc_name
  region       = var.region
  cidr_range   = var.dev_cidr_range
}
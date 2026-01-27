module "vpc_dev" {
  source       = "../../ps-ledger-infra-modules-tf/modules/vpc"
  network_name = var.dev_vpc_name
  region       = var.region
  cidr_range   = var.dev_cidr_range
}

module "nat" {
  source       = "../../ps-ledger-infra-modules-tf/modules/nat"
  network_name = var.dev_vpc_name
  region       = var.region
  network_id   = module.vpc_dev.network_id
}

module "private_service_access" {
  source             = "../../ps-ledger-infra-modules-tf/modules/private-service-access"
  project_id         = var.project_id
  vpc_id             = module.vpc_dev.network_id
  peering_range_name = "google-managed-services-dev"
}
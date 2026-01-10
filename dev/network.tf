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

module "vpc_dev" {
  source = "../../ps-ledger-infra-modules-tf/modules/vpc"

  network_name = var.dev_vpc_name
  region       = var.region
  cidr_range   = var.dev_cidr_range
}

#Firewall Rules
module "firewall_rules_dev" {
  source = "../../ps-ledger-infra-modules-tf/modules/firewall"

  network_name = module.vpc_dev.network_name
}

module "nat" {
    source       = "../../ps-ledger-infra-modules-tf/modules/nat"
    network_name = var.dev_vpc_name
    region       = var.region
    network_id   = module.vpc_dev.network_id
    depends_on = [ module.vpc_dev ]
} 
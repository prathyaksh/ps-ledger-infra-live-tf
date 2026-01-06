module "nat" {
    source       = "../../ps-ledger-infra-modules-tf/modules/nat"
    network_name = var.dev_vpc_name
    region       = var.region
    network_id   = module.vpc_dev.network_id
}
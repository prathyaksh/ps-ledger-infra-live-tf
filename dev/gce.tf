module "ledger_vm" {
  source       = "../../ps-ledger-infra-modules-tf/modules/gce"
  instance_name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  subnet_self_link = module.vpc_dev.subnet_self_link
  network_self_link = module.vpc_dev.network_self_link
  target_tags      = ["ssh-access"]
  email = module.create_ledger_sa.email
}
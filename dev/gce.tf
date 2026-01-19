module "ledger_vm" {
  source           = "../../ps-ledger-infra-modules-tf/modules/gce"
  instance_name    = var.instance_name
  machine_type     = var.machine_type
  zone             = var.zone
  os_image         = "ubuntu-os-cloud/ubuntu-2204-lts"
  
  labels = {
    app         = "finance-ledger"
    environment = "dev"
  }

  # THIS CALLS THE EXTERNAL FILE.
  startup_script = file("${path.module}/gce_startup_scripts/startup.sh")

  subnet_self_link  = module.vpc_dev.subnet_self_link
  network_self_link = module.vpc_dev.network_self_link
  target_tags       = ["ssh-access", "http-server"]
  email             = module.create_ledger_sa.sa_email
  
  depends_on = [
    module.firewall_rules
  ]
}
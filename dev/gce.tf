moved {
  from = module.ledger_vm.google_compute_instance.finance_app_instance
  to   = module.ledger_vm.google_compute_instance.vm_instance
}

module "ledger_vm" {
  source            = "../../ps-ledger-infra-modules-tf/modules/gce"
  instance_name     = var.instance_name
  machine_type      = var.machine_type
  zone              = var.zone
  
  # NEW UNIVERSAL FIELDS
  os_image          = "ubuntu-os-cloud/ubuntu-2204-lts"
  labels = {
    app         = "finance-ledger"
    environment = "dev"
  }

  # THIS REPLACES ANSIBLE
  # It installs Nginx and creates a basic landing page automatically
  startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    echo "<h1>Financial Ledger - System Online</h1>" > /var/www/html/index.html
    systemctl restart nginx
  EOT

  subnet_self_link  = module.vpc_dev.subnet_self_link
  network_self_link = module.vpc_dev.network_self_link
  target_tags       = ["ssh-access", "http-server"] # Added http-server tag
  email             = join("", module.create_ledger_sa.sa_email)
}


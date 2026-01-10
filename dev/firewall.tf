module "firewall_rules" {
  source       = "../../ps-ledger-infra-modules-tf/modules/firewall"
  network_name = module.vpc_dev.network_name

  firewall_rules = {
    "allow-iap-ssh" = {
      action        = "allow"        # Added this
      protocol      = "tcp"
      ports         = ["22"]
      source_ranges = ["35.235.240.0/20"]
      target_tags   = ["ssh-access"]
    },
    "allow-http-web" = {
      action        = "allow"        # Added this
      protocol      = "tcp"
      ports         = ["80"]
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["http-server"]
    }
  }
}
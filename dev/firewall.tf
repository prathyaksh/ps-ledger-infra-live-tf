module "firewall_rules" {
  source       = "../../ps-ledger-infra-modules-tf/modules/firewall"
  network_name = module.vpc_dev.network_name

  firewall_rules = {
    # Rule 1: SECURE SSH via IAP (Only Google's Proxy Range)
    "allow-iap-ssh" = {
      allow = [
        {
         protocol = "tcp",
         ports = ["22"] 
         }
         ]
      source_ranges = ["35.235.240.0/20"] # Google's IAP Range
      target_tags   = ["ssh-access"]
    },
    
    # Rule 2: PUBLIC HTTP (For our Nginx Landing Page)
    "allow-http-web" = {
      allow = [
        {
         protocol = "tcp",
         ports = ["80"] 
         }
         ]
      source_ranges = ["0.0.0.0/0"] # The Internet
      target_tags   = ["http-server"]
    }
  }
}
module "ledger_lb" {
  source            = "../../ps-ledger-infra-modules-tf/modules/lb"
  name              = "ledger-app-lb"
  backend_groups    = [module.ledger_mig.instance_group_self_link]
  backend_port_name = "http" # This MUST match the name used in uig.tf
  lb_port           = "80"
}

# Output the IP so we don't have to look for it in the console
output "load_balancer_public_ip" {
  value = module.ledger_lb.lb_ip
}
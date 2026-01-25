module "ledger_mig" {
  source = "../../ps-ledger-infra-modules-tf/modules/mig-compute"

  name                 = "ledger-app"
  project_id           = var.project_id
  region               = "asia-south1"
  target_size          = 1
  
  # The Bridge: Getting the ID from the template module we just created
  instance_template_id = module.ledger_template.template_id 
  
  # Task 3: Link your existing LB health check here
  health_check_id      = module.ledger_lb.health_check_id 
}
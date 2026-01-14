module "ledger_dashboard" {
  source = "../../ps-ledger-infra-modules-tf/modules/monitoring"

  # Pass these directly to the module
  project_id     = var.project_id
  dashboard_name = "Financial-Ledger-SRE-Dashboard"
  lb_ip          = "" 

  dashboard_json = templatefile("${path.module}/monitoring-templates/fin-ledger-sre-dashboard.json.tftpl", {
    dashboard_name = "Financial-Ledger-SRE-Dashboard"
    project_id     = var.project_id
    lb_name        = "ledger-app-lb"
  })
}

# 2. The NEW Alerts Call
module "ledger_alerts" {
  source = "../../ps-ledger-infra-modules-tf/modules/monitoring"

  project_id     = var.project_id
  lb_ip          = module.ledger_lb.lb_ip
  dashboard_name = "Ledger-Alerts"

  dashboard_json = "" 
}
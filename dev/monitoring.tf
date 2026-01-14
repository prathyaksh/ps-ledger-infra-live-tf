module "ledger_dashboard" {
  source = "../../ps-ledger-infra-modules-tf/modules/monitoring"

  # We pass a template file and inject our project specific variables into it
  dashboard_json = templatefile("${path.module}/monitoring-templates/fin-ledger-sre-dashboard.json.tftpl", {
    dashboard_name = "Financial-Ledger-SRE-Dashboard"
    project_id     = var.project_id
    lb_name        = "ledger-app-lb" # This matches our LB module name
  })
}

# 2. The NEW Alerts Call - This handles the Uptime Checks and Policies
module "ledger_alerts" {
  source = "../../ps-ledger-infra-modules-tf/modules/monitoring"

  project_id     = var.project_id
  lb_ip          = module.ledger_lb.lb_ip
  dashboard_name = "Ledger-Alerts"
  
  # We pass an empty string here because this call is NOT for a dashboard
  # (Requires a small tweak to our module to make dashboard creation optional)
  dashboard_json = "" 
}
module "ledger_dashboard" {
  source = "../../ps-ledger-infra-modules-tf/modules/monitoring"

  # We pass a template file and inject our project specific variables into it
  dashboard_json = templatefile("${path.module}/monitoring-templates/fin-ledger-sre-dashboard.json.tftpl", {
    dashboard_name = "Financial-Ledger-SRE-Dashboard"
    project_id     = var.project_id
    lb_name        = "ledger-app-lb" # This matches our LB module name
  })
}
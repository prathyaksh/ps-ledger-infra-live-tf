module "ledger_dashboard" {
  source = "../../ps-ledger-infra-modules-tf/modules/monitoring"

  project_id     = var.project_id
  dashboard_name = "Financial-Ledger-SRE-Dashboard"
  lb_ip          = "" 
  alert_email_address = ""

  dashboard_json = templatefile("${path.module}/monitoring-templates/fin-ledger-sre-dashboard.json.tftpl", {
    dashboard_name = "Financial-Ledger-SRE-Dashboard"
    project_id     = var.project_id
    lb_name        = "ledger-app-lb"
  })

  # Empty maps so no alerts are created for the dashboard-only call
  threshold_alerts = {}
  absence_alerts   = {}
}

module "ledger_alerts" {
  source = "../../ps-ledger-infra-modules-tf/modules/monitoring"

  project_id          = var.project_id
  lb_ip               = module.ledger_lb.lb_ip
  dashboard_name      = "Ledger-Alerts"
  dashboard_json      = "" 
  alert_email_address = "your-email@example.com"

  # Defining the "Molds" here
  threshold_alerts = {
    "uptime" = {
      display_name = "Alert: Ledger Site Down (Uptime Check)"
      filter       = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\""
      duration     = "60s"
      comparison   = "COMPARISON_LT"
      threshold    = 1
      severity     = "critical"
    },
    "cpu" = {
      display_name = "Alert: High CPU Utilization (>80%)"
      filter       = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      duration     = "300s"
      comparison   = "COMPARISON_GT"
      threshold    = 0.8
      severity     = "warning"
    }
  }

  absence_alerts = {
    "traffic" = {
      display_name = "Alert: NO TRAFFIC DETECTED (System Dark)"
      filter       = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" resource.type=\"https_lb_rule\" resource.labels.url_map_name=\"ledger-app-lb-url-map\""
      duration     = "600s"
    }
  }
}
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
  alert_email_address = "ps.prathyaksh@gmail.com"

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


## 4 golden signals ##

resource "google_logging_metric" "nginx_error_count" {
  name   = "nginx_error_count"
  filter = "resource.type=\"gce_instance\" AND log_id(\"nginx_access\") AND httpRequest.status >= 400"
  
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

resource "google_monitoring_dashboard" "golden_signals" {
  dashboard_json = <<EOF
{
  "displayName": "Financial Ledger - 4 Golden Signals",
  "gridLayout": {
    "columns": "2",
    "widgets": [
      {
        "title": "1. Traffic (Requests/sec)",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"workload.googleapis.com/nginx.requests\" resource.type=\"gce_instance\"",
                "aggregation": { "perSeriesAligner": "ALIGN_RATE" }
              }
            }
          }]
        }
      },
      {
        "title": "2. Errors (4xx/5xx Count)",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"logging.googleapis.com/user/nginx_error_count\" resource.type=\"gce_instance\"",
                "aggregation": { "perSeriesAligner": "ALIGN_DELTA" }
              }
            }
          }]
        }
      },
      {
        "title": "3. Latency (P95 ms)",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"loadbalancing.googleapis.com/https/total_latencies\" resource.type=\"https_lb_rule\"",
                "aggregation": { "perSeriesAligner": "ALIGN_PERCENTILE_95" }
              }
            }
          }]
        }
      },
      {
        "title": "4. Saturation (CPU %)",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\"",
                "aggregation": { "perSeriesAligner": "ALIGN_MEAN" }
              }
            }
          }]
        }
      }
    ]
  }
}
EOF
}
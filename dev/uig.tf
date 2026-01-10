module "ledger_uig" {
  source     = "../../ps-ledger-infra-modules-tf/modules/uig"
  group_name = "ledger-vm-group"
  zone       = var.zone
  named_ports = [
    { name = "http"
      port = 80 
    }
    ]
  # We take the self_link output from your GCE module
  instances  = [module.ledger_vm.instance_self_link]
}
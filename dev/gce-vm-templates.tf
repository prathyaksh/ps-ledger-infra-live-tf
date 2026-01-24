module "ledger_template" {
  source = "../../ps-ledger-infra-modules-tf/modules/compute-group-template"

  # Fixing the error: Passing the 'prefix' variable
  prefix                = "ledger-app" 
  
  project_id            = var.project_id
  region                = "asia-south1"
  machine_type          = "e2-medium"
  source_image          = "ubuntu-os-cloud/ubuntu-2204-lts"
  disk_type             = "pd-standard"
  
  # These are usually outputs from your network and iam modules
  network_id            = module.vpc_dev.network_self_link
  subnet_id             = module.vpc_dev.subnet_self_link
  service_account_email = module.create_ledger_sa.sa_email
  
  # Point this to the actual path of your script
  startup_script        = file("${path.module}/gce_startup_scripts/startup.sh")
  
  tags                  = ["http-server", "ledger-app"]
}
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
  network_id            = module.vpc.network_id
  subnet_id             = module.vpc.subnet_id
  service_account_email = module.iam.service_account_email
  
  # Point this to the actual path of your script
  startup_script        = file("${path.module}/scripts/install-nginx.sh")
  
  tags                  = ["http-server", "ledger-app"]
}
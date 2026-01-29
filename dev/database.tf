module "ledger_db" {
  source = "../../ps-ledger-infra-modules-tf/modules/cloud-sql"

  # PROVIDE THE MISSING MANDATORY ARGUMENTS
  project_id           = var.project_id
  database_version     = "POSTGRES_15"

  instance_name     = "ledger-db"
  environment       = "dev"
  region            = var.region
  vpc_id            = module.vpc_dev.network_id 
  
  db_password       = var.db_password
  db_user_name      = "ledger_admin"
  db_name           = "ledger_app_db"

  tier              = "db-f1-micro"
  availability_type = "ZONAL"
  disk_type         = "PD_SSD"
  backup_enabled    = true
}
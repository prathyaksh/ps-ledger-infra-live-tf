# 3. The PostgreSQL Instance (Cloud SQL)
module "ledger_db" {
  source = "../../ps-ledger-infra-modules-tf/modules/cloud-sql"

  instance_name     = "ledger-db"
  environment       = "dev"
  region            = var.region
  vpc_id            = module.vpc_dev.network_id # Linked to our network highway
  
  # Credentials (passed from a sensitive variable for now)
  db_password       = var.db_password
  db_user_name      = "ledger_admin"
  db_name           = "ledger_app_db"

  # SRE Sizing (Flexible Blueprint)
  tier              = "db-f1-micro"
  availability_type = "ZONAL"
  disk_type         = "PD_SSD"
  backup_enabled    = true
}
module "kms" {
  source      = "../../ps-ledger-infra-modules-tf/modules/kms"
  name        = "ledger"
  db_key_name = "ledger-db-key"
  region      = var.region
}

module "secrets" {
  source     = "../../ps-ledger-infra-modules-tf/modules/secret-manager"
  name       = "ledger"
  region     = var.region
  kms_key_id = module.kms.key_id
}
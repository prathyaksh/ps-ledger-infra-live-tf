# 1. JUST create a Service Account
module "create_ledger_sa" {
  source       = "../../ps-ledger-infra-modules-tf/modules/iam"
  project_id   = var.project_id
  create_sa    = true
  sa_id        = "fin-ledger-sa"
  display_name = "Finance App SA"
}

# 2. JUST add roles to the SA (Independent call)
module "assign_sa_roles" {
  source     = "../../ps-ledger-infra-modules-tf/modules/iam"
  project_id = var.project_id
  member_id  = "serviceAccount:fin-ledger-sa@${var.project_id}.iam.gserviceaccount.com"
  roles_list = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

# 3. JUST add roles to YOUR human ID (Independent call)
module "assign_my_user_roles" {
  source     = "../../ps-ledger-infra-modules-tf/modules/iam"
  project_id = var.project_id
  member_id  = "user:prathyaksh.ps@gmail.com"
  roles_list = [
    "roles/iap.tunnelResourceAccessor",
    "roles/compute.viewer"
  ]
}

module "secret_manager_iam" {
  source       = "../../ps-ledger-infra-modules-tf/modules/iam"
  project_id   = var.project_id
  service_name = "secretmanager.googleapis.com"
  kms_key_id   = module.kms.key_id
  role         = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}
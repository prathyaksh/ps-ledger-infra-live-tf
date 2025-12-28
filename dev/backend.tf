
terraform {
  backend "gcs" {
    bucket  = "ps-dev-tf-state-bucket-finance-app" # The name of the bucket you just created
    prefix  = "terraform/state"              # The path inside the bucket
  }
}
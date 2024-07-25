module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account"

  name      = "iam"
  folder_id = "xxxx"
  folder_roles = [
    "admin",
  ]
  cloud_roles              = []
  enable_static_access_key = false
  enable_api_key           = false
  enable_account_key       = false

}

module "clickhouse" {
  source = "../"

  folder_id    = "xxxx"
  yc_zone      = "ru-central1-a"

  cluster_name = "test-clickhouse-cluster"
  environment  = "PRODUCTION"

  resource_preset_id = "s2.micro"
  disk_type_id       = "network-ssd"
  disk_size          = 32

  database_name = "db_name"
  user_name     = "user"
  user_password = "your_password"

  service_account_id = module.iam_accounts.id
}

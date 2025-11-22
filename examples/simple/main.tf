data "yandex_client_config" "client" {}

module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account?ref=v1.0.0"

  name = "iam"
  folder_roles = [
    "admin",
  ]
  cloud_roles              = []
  enable_static_access_key = false
  enable_api_key           = false
  enable_account_key       = false

}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.0.0"

  folder_id = data.yandex_client_config.client.folder_id

  blank_name = "clickhouse-vpc-nat-gateway"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-vpc"
  }

  azs = ["ru-central1-a"]

  private_subnets = [["10.3.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}


module "clickhouse" {
  source = "../../"

  network_id = module.network.vpc_id

  users = [
    {
      name     = "user1"
      password = "password1"
    }
  ]

  databases = [
    {
      name = "db_name"
    }
  ]

  hosts = [
    {
      type             = "CLICKHOUSE"
      zone             = "ru-central1-a"
      subnet_id        = module.network.private_subnets_ids[0]
      assign_public_ip = true
    }
  ]

  name                          = "clickhouse-cluster"
  clickhouse_disk_size          = 10
  clickhouse_disk_type_id       = "network-ssd"
  clickhouse_resource_preset_id = "s3-c2-m8"
  environment                   = "PRODUCTION"
  clickhouse_version            = "24.8"
  description                   = "ClickHouse cluster description"
  folder_id                     = data.yandex_client_config.client.folder_id

  zookeeper_disk_size          = 20
  zookeeper_disk_type_id       = "network-ssd"
  zookeeper_resource_preset_id = "s3-c2-m8"

  admin_password = "MyClusterAdminPasswordSecure123$"

  sql_user_management     = false
  sql_database_management = false

  embedded_keeper          = false
  copy_schema_on_new_hosts = true
  deletion_protection      = false

  labels = {
    project     = "default-project",
    environment = "development"
  }

  backup_window_start = {
    hours   = "03"
    minutes = "00"
  }

  access = {
    web_sql       = true
    data_lens     = false
    yandex_query  = false
    data_transfer = false
  }

  maintenance_window = {
    type = "WEEKLY"
    day  = "SAT"
    hour = "01"
  }

  clickhouse_config = {
    log_level                = "INFORMATION"
    timezone                 = "Europe/Moscow"
    max_concurrent_queries   = 100
    keep_alive_timeout       = 300
    metric_log_enabled       = true
    query_log_retention_size = 2147483648
    merge_tree = {
      parts_to_throw_insert = 300
    }
  }

  depends_on = [module.iam_accounts, module.network]

  timeouts = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

}

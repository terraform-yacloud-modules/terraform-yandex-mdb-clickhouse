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
  source = "../"

  network_id = module.network.vpc_id

  users = [
    {
      name     = "user1"
      password = "password1"
      quota    = [
        {
          interval_duration = "3600000"
          queries           = 10000
          errors            = 1000
        }
      ]
      permission = [
        {
          database_name = "db_name"
        }
      ]
      settings = {
        max_memory_usage_for_user               = 1000000000
        read_overflow_mode                      = "throw"
        output_format_json_quote_64bit_integers = true
      }
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

  # Optional variables
  name                        = "clickhouse-cluster"
  clickhouse_disk_size         = 10
  clickhouse_disk_type_id      = "network-ssd"
  clickhouse_resource_preset_id = "s3-c2-m8"
  environment                 = "PRODUCTION"
  clickhouse_version          = "23.8"
  description                 = "ClickHouse cluster description"
  folder_id                   = data.yandex_client_config.client.folder_id
  labels                      = {}
  backup_window_start         = {
    hours   = "03"
    minutes = "00"
  }
  access                      = {
    data_lens     = false
    metrika       = false
    web_sql       = false
    serverless    = false
    yandex_query  = false
    data_transfer = false
  }
  zookeeper_disk_size         = 33
  zookeeper_disk_type_id      = "network-ssd"
  zookeeper_resource_preset_id = "b3-c1-m4"
  shard_group                 = {
    name        = "single_shard_group"
    shard_names = ["shard1"]
    description = "Cluster configuration that contain only shard1"
  }

  depends_on = [module.iam_accounts, module.network]
}

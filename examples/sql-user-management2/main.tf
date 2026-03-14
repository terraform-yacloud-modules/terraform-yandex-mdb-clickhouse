data "yandex_client_config" "client" {}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.0.0"

  folder_id = data.yandex_client_config.client.folder_id

  blank_name = "clickhouse-vpc-nat-gateway"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-vpc"
  }

  azs = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

  private_subnets = [["10.4.0.0/24"], ["10.5.0.0/24"], ["10.6.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}


module "clickhouse" {
  source = "../../"

  network_id = module.network.vpc_id

  hosts = [
    {
      type             = "CLICKHOUSE"
      zone             = "ru-central1-a"
      subnet_id        = module.network.private_subnets_ids[0]
      assign_public_ip = true
    },
    {
      type      = "ZOOKEEPER"
      zone      = "ru-central1-a"
      subnet_id = module.network.private_subnets_ids[0]
    },
    {
      type      = "ZOOKEEPER"
      zone      = "ru-central1-b"
      subnet_id = module.network.private_subnets_ids[1]
    },
    {
      type      = "ZOOKEEPER"
      zone      = "ru-central1-d"
      subnet_id = module.network.private_subnets_ids[2]
    }
  ]

  name = "my-prod-ch-cluster"

  clickhouse_disk_size = 100

  clickhouse_disk_type_id = "network-ssd"

  clickhouse_resource_preset_id = "s3-c2-m8"

  environment = "PRODUCTION"

  clickhouse_version = "25.8"

  description = "Production ClickHouse cluster for advanced analytics and reporting."

  labels = {
    project     = "alpha-project",
    environment = "production",
    sla         = "high"
  }

  backup_window_start = {
    hours   = 2
    minutes = 30
  }

  access = {
    data_lens     = true
    metrika       = false
    web_sql       = true
    serverless    = true
    yandex_query  = true
    data_transfer = true
  }

  zookeeper_disk_size          = 20
  zookeeper_disk_type_id       = "network-ssd"
  zookeeper_resource_preset_id = "s3-c2-m8"

  admin_password = "MyClusterAdminPasswordSecure123$"

  sql_user_management = true

  sql_database_management = true

  embedded_keeper = false

  copy_schema_on_new_hosts = true

  deletion_protection = false

  maintenance_window = {
    type = "WEEKLY"
    day  = "SAT"
    hour = 1
  }

  clickhouse_config = {
    log_level                = "INFORMATION"
    timezone                 = "Asia/Omsk"
    geobase_enabled          = false
    dictionaries_lazy_load   = true
    metric_log_enabled       = true
    query_log_retention_size = 21474836480
    query_log_retention_time = 604800000
    text_log_enabled         = true
    text_log_level           = "WARNING"
    text_log_retention_size  = 5368709120

    max_concurrent_queries = 300
    max_connections        = 2048
    keep_alive_timeout     = 300

    merge_tree = {
      max_bytes_to_merge_at_min_space_in_pool = 107374182400
      parts_to_throw_insert                   = 600
      replicated_deduplication_window         = 200
      min_bytes_for_wide_part                 = 104857600
    }

    compression = {
      method              = "ZSTD"
      min_part_size       = 10485760
      min_part_size_ratio = 0.01
      level               = 3
    }

    query_cache = {
      max_size_in_bytes       = 536870912
      max_entries             = 512
      max_entry_size_in_bytes = 524288
      max_entry_size_in_rows  = 15000000
    }

    # Маскирование чувствительных данных в логах (актуально при sql_user_management)
    query_masking_rules = [
      {
        name    = "mask_password"
        regexp  = "(?i)password\\s*=\\s*['\"]?[^'\"\\s]+['\"]?"
        replace = "password=******"
      }
    ]
  }

  depends_on = [module.network]
}

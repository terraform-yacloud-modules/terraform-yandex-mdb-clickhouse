data "yandex_client_config" "client" {}

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
      name     = "developer"
      password = "MySecurePassword123!"
      permission = [
        {
          database_name = "main_database"
        },
        {
          database_name = "analytics_data"
        }
      ]
      settings = {
        readonly         = 0
        max_memory_usage = 10737418240
        connect_timeout  = 1000
      }
    },
    {
      name = "reporter"
      permission = [
        {
          database_name = "analytics_data"
        }
      ]
      settings = {
        readonly = 1
      }
    }
  ]

  databases = [
    {
      name = "main_database"
    },
    {
      name = "analytics_data"
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

  name                          = "my-ch-cluster-stage"
  description                   = "Кластер ClickHouse для staging окружения"
  clickhouse_version            = "24.8"
  environment                   = "PRESTABLE"
  clickhouse_resource_preset_id = "s3-c2-m8"
  clickhouse_disk_size          = 50
  clickhouse_disk_type_id       = "network-ssd"
  embedded_keeper               = true
  deletion_protection           = false

  labels = {
    project     = "alpha-project"
    environment = "staging"
    owner       = "data-team"
  }

  access = {
    web_sql       = true
    data_lens     = true
    yandex_query  = false
    data_transfer = true
  }

  backup_window_start = {
    hours   = "03"
    minutes = "00"
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

  depends_on = [module.network]
}

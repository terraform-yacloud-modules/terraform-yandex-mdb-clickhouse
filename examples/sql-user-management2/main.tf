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

  # Список хостов кластера ClickHouse и ZooKeeper (если embedded_keeper = false).
  # Убедитесь, что subnet_id существуют и находятся в указанных зонах доступности и сети network_id.
  hosts = [
    # Хосты ClickHouse
    {
      type             = "CLICKHOUSE"
      zone             = "ru-central1-a"
      subnet_id        = module.network.private_subnets_ids[0]
      assign_public_ip = true # Пример: один хост с публичным IP для прямого доступа
    },
    # Хосты ZooKeeper (требуются, если embedded_keeper = false)
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

  # Имя кластера ClickHouse.
  name = "my-prod-ch-cluster"

  # Размер диска для хостов ClickHouse в ГБ.
  clickhouse_disk_size = 100

  # Тип диска для хостов ClickHouse.
  # Возможные значения: "network-hdd", "network-ssd", "network-ssd-nonreplicated", "local-ssd".
  clickhouse_disk_type_id = "network-ssd"

  # Пресет вычислительных ресурсов для хостов ClickHouse.
  # Список доступных пресетов: https://cloud.yandex.com/en/docs/managed-clickhouse/concepts/instance-types
  clickhouse_resource_preset_id = "s3-c2-m8"

  # Окружение кластера. "PRODUCTION" или "PRESTABLE".
  environment = "PRODUCTION"

  # Версия ClickHouse.
  clickhouse_version = "24.8" # Укажите актуальную поддерживаемую версию

  # Описание кластера.
  description = "Production ClickHouse cluster for advanced analytics and reporting."

  # Метки для кластера.
  labels = {
    project     = "alpha-project",
    environment = "production",
    sla         = "high"
  }

  # Время начала ежедневного резервного копирования (UTC).
  backup_window_start = {
    hours   = "02" # 02:00 UTC
    minutes = "30" # 02:30 UTC
  }

  # Политики доступа к кластеру из других сервисов Yandex Cloud.
  access = {
    data_lens     = true  # Разрешить доступ из Yandex DataLens
    metrika       = false # Запретить доступ из AppMetrica / Yandex Metrica
    web_sql       = true  # Разрешить доступ через веб-консоль SQL
    serverless    = true  # Разрешить доступ из Yandex Cloud Functions и API Gateway
    yandex_query  = true  # Разрешить доступ из Yandex Query
    data_transfer = true  # Разрешить доступ для Yandex Data Transfer
  }

  # Параметры для хостов ZooKeeper (используются, если embedded_keeper = false).
  # Размер диска для хостов ZooKeeper в ГБ.
  zookeeper_disk_size = 20
  # Тип диска для хостов ZooKeeper.
  zookeeper_disk_type_id = "network-ssd"
  # Пресет вычислительных ресурсов для хостов ZooKeeper.
  zookeeper_resource_preset_id = "s3-c2-m8" # 2 vCPU, 8 GB RAM (стандартный выбор для ZK)

  # Пароль для пользователя 'admin' при включенном sql_user_management.
  # Обязательно установите, если sql_user_management = true.
  admin_password = "MyClusterAdminPasswordSecure123$"

  # Включение управления пользователями через SQL-команды (пользователь admin).
  sql_user_management = true

  # Предоставление пользователю admin прав на управление базами данных.
  sql_database_management = true

  # Использование встроенного ClickHouse Keeper вместо отдельных хостов ZooKeeper.
  # Если true, хосты ZooKeeper (type="ZOOKEEPER") в 'hosts' не нужны, и параметры zookeeper_* игнорируются.
  # Для данного примера мы используем внешние хосты ZK, поэтому false.
  embedded_keeper = false

  # Копирование схемы данных на новые хосты ClickHouse при масштабировании.
  copy_schema_on_new_hosts = true

  # Защита кластера от случайного удаления.
  deletion_protection = true

  # Окно обслуживания кластера.
  maintenance_window = {
    type = "WEEKLY" # Тип окна: ANYTIME или WEEKLY
    day  = "SAT"    # День недели для обслуживания (MON, TUE, WED, THU, FRI, SAT, SUN)
    hour = "01"     # Час начала обслуживания в UTC (0-23)
  }

  # Расширенная конфигурация ClickHouse (секция <yandex> в config.xml).
  # Задаются только необходимые или измененные параметры.
  clickhouse_config = {
    # Настройки логирования
    log_level                = "INFORMATION" # Уровни: TRACE, DEBUG, INFORMATION, WARNING, ERROR
    metric_log_enabled       = true
    query_log_retention_size = 21474836480 # 20GB
    query_log_retention_time = 604800000   # 7 дней в миллисекундах
    text_log_enabled         = true
    text_log_level           = "WARNING"
    text_log_retention_size  = 5368709120 # 5GB

    # Настройки производительности и соединений
    max_concurrent_queries = 300
    max_connections        = 2048
    keep_alive_timeout     = 300 # Секунды

    # Настройки MergeTree таблиц
    merge_tree = {
      max_bytes_to_merge_at_min_space_in_pool = 107374182400 # 100GB
      parts_to_throw_insert                   = 600          # Порог для ошибки "Too many parts"
      replicated_deduplication_window         = 200
      min_bytes_for_wide_part                 = 104857600 # 100MB
    }

    # Настройки компрессии по умолчанию (если не указаны в таблице)
    compression = {
      method              = "ZSTD"   # Более сильное сжатие
      min_part_size       = 10485760 # 10MB
      min_part_size_ratio = 0.01
    }

    # Часовой пояс сервера
    timezone = "Asia/Omsk"

  }

  depends_on = [module.network]
}

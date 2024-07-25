provider "yandex" {
  folder_id = var.folder_id
  zone      = var.yc_zone
}

resource "yandex_vpc_network" "clickhouse_network" {
  name = "clickhouse-network"
}

resource "yandex_vpc_subnet" "clickhouse_subnet" {
  name           = "clickhouse-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.clickhouse_network.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_mdb_clickhouse_cluster" "clickhouse_cluster" {
  name        = var.cluster_name
  environment = var.environment
  network_id  = yandex_vpc_network.clickhouse_network.id

  clickhouse {
    resources {
      resource_preset_id = var.resource_preset_id
      disk_type_id       = var.disk_type_id
      disk_size          = var.disk_size
    }

    config {
      log_level                       = var.log_level
      max_connections                 = var.max_connections
      max_concurrent_queries          = var.max_concurrent_queries
      keep_alive_timeout              = var.keep_alive_timeout
      uncompressed_cache_size         = var.uncompressed_cache_size
      mark_cache_size                 = var.mark_cache_size
      max_table_size_to_drop          = var.max_table_size_to_drop
      max_partition_size_to_drop      = var.max_partition_size_to_drop
      timezone                        = var.timezone
      geobase_uri                     = var.geobase_uri
      query_log_retention_size        = var.query_log_retention_size
      query_log_retention_time        = var.query_log_retention_time
      query_thread_log_enabled        = var.query_thread_log_enabled
      query_thread_log_retention_size = var.query_thread_log_retention_size
      query_thread_log_retention_time = var.query_thread_log_retention_time
      part_log_retention_size         = var.part_log_retention_size
      part_log_retention_time         = var.part_log_retention_time
      metric_log_enabled              = var.metric_log_enabled
      metric_log_retention_size       = var.metric_log_retention_size
      metric_log_retention_time       = var.metric_log_retention_time
      trace_log_enabled               = var.trace_log_enabled
      trace_log_retention_size        = var.trace_log_retention_size
      trace_log_retention_time        = var.trace_log_retention_time
      text_log_enabled                = var.text_log_enabled
      text_log_retention_size         = var.text_log_retention_size
      text_log_retention_time         = var.text_log_retention_time
      text_log_level                  = var.text_log_level
      background_pool_size            = var.background_pool_size
      background_schedule_pool_size   = var.background_schedule_pool_size

      merge_tree {
        replicated_deduplication_window                           = var.replicated_deduplication_window
        replicated_deduplication_window_seconds                   = var.replicated_deduplication_window_seconds
        parts_to_delay_insert                                     = var.parts_to_delay_insert
        parts_to_throw_insert                                     = var.parts_to_throw_insert
        max_replicated_merges_in_queue                            = var.max_replicated_merges_in_queue
        number_of_free_entries_in_pool_to_lower_max_size_of_merge = var.number_of_free_entries_in_pool_to_lower_max_size_of_merge
        max_bytes_to_merge_at_min_space_in_pool                   = var.max_bytes_to_merge_at_min_space_in_pool
      }

      kafka {
        security_protocol = var.kafka_security_protocol
        sasl_mechanism    = var.kafka_sasl_mechanism
        sasl_username     = var.kafka_sasl_username
        sasl_password     = var.kafka_sasl_password
      }

      kafka_topic {
        name = var.kafka_topic_name
        settings {
          security_protocol = var.kafka_topic_security_protocol
          sasl_mechanism    = var.kafka_topic_sasl_mechanism
          sasl_username     = var.kafka_topic_sasl_username
          sasl_password     = var.kafka_topic_sasl_password
        }
      }

      rabbitmq {
        username = var.rabbitmq_username
        password = var.rabbitmq_password
      }

      compression {
        method              = var.compression_method
        min_part_size       = var.compression_min_part_size
        min_part_size_ratio = var.compression_min_part_size_ratio
      }

      graphite_rollup {
        name = var.graphite_rollup_name
        pattern {
          regexp   = var.graphite_rollup_regexp
          function = var.graphite_rollup_function
          retention {
            age       = var.graphite_rollup_retention_age
            precision = var.graphite_rollup_retention_precision
          }
        }
      }
    }
  }

  database {
    name = var.database_name
  }

  user {
    name     = var.user_name
    password = var.user_password
    permission {
      database_name = var.database_name
    }
    settings {
      max_memory_usage_for_user               = var.max_memory_usage_for_user
      read_overflow_mode                      = var.read_overflow_mode
      output_format_json_quote_64bit_integers = var.output_format_json_quote_64bit_integers
    }
    quota {
      interval_duration = var.quota_interval_duration
      queries           = var.quota_queries
      errors            = var.quota_errors
    }
  }

  host {
    type      = "CLICKHOUSE"
    zone      = var.yc_zone
    subnet_id = yandex_vpc_subnet.clickhouse_subnet.id
  }

  service_account_id = var.service_account_id

  cloud_storage {
    enabled = var.cloud_storage_enabled
  }

  maintenance_window {
    type = var.maintenance_window_type
  }
}

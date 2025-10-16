data "yandex_client_config" "client" {}

locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
}

resource "random_password" "password" {
  for_each         = { for v in var.users : v.name => v if v.password == null }
  length           = 16
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "_"
}

# ClickHouse cluster
resource "yandex_mdb_clickhouse_cluster" "this" {
  name        = var.name
  network_id  = var.network_id
  environment = var.environment

  version             = var.clickhouse_version
  description         = var.description
  folder_id           = local.folder_id
  labels              = var.labels
  security_group_ids  = var.security_group_ids
  deletion_protection = var.deletion_protection

  clickhouse {
    resources {
      disk_size          = var.clickhouse_disk_size
      disk_type_id       = var.clickhouse_disk_type_id
      resource_preset_id = var.clickhouse_resource_preset_id
    }
    dynamic "config" {
      for_each = range(var.clickhouse_config == null ? 0 : 1)
      content {
        background_fetches_pool_size  = var.clickhouse_config.background_fetches_pool_size
        background_pool_size          = var.clickhouse_config.background_pool_size
        background_schedule_pool_size = var.clickhouse_config.background_schedule_pool_size

        dynamic "compression" {
          for_each = range(var.clickhouse_config.compression == null ? 0 : 1)
          content {
            method              = var.clickhouse_config.compression.method
            min_part_size       = var.clickhouse_config.compression.min_part_size
            min_part_size_ratio = var.clickhouse_config.compression.min_part_size_ratio
          }
        }

        default_database = var.clickhouse_config.default_database
        geobase_uri      = var.clickhouse_config.geobase_uri

        dynamic "graphite_rollup" {
          for_each = range(var.clickhouse_config.graphite_rollup == null ? 0 : 1)
          content {
            name = var.clickhouse_config.graphite_rollup.name
            pattern {
              function = var.clickhouse_config.graphite_rollup.pattern.function
              regexp   = var.clickhouse_config.graphite_rollup.pattern.regexp
              retention {
                age       = var.clickhouse_config.graphite_rollup.pattern.retention.age
                precision = var.clickhouse_config.graphite_rollup.pattern.retention.precision
              }
            }
          }
        }

        dynamic "kafka" {
          for_each = range(var.clickhouse_config.kafka == null ? 0 : 1)
          content {
            security_protocol = var.clickhouse_config.kafka.security_protocol
            sasl_mechanism    = var.clickhouse_config.kafka.sasl_mechanism
            sasl_username     = var.clickhouse_config.kafka.sasl_username
            sasl_password     = var.clickhouse_config.kafka.sasl_password
          }
        }

        dynamic "kafka_topic" {
          for_each = range(var.clickhouse_config.kafka_topic == null ? 0 : 1)
          content {
            name = var.clickhouse_config.kafka_topic.name
            dynamic "settings" {
              for_each = range(var.clickhouse_config.kafka_topic.settings == null ? 0 : 1)
              content {
                security_protocol = var.clickhouse_config.kafka_topic.security_protocol
                sasl_mechanism    = var.clickhouse_config.kafka_topic.sasl_mechanism
                sasl_username     = var.clickhouse_config.kafka_topic.sasl_username
                sasl_password     = var.clickhouse_config.kafka_topic.sasl_password
              }
            }
          }
        }

        keep_alive_timeout         = var.clickhouse_config.keep_alive_timeout
        log_level                  = var.clickhouse_config.log_level
        mark_cache_size            = var.clickhouse_config.mark_cache_size
        max_concurrent_queries     = var.clickhouse_config.max_concurrent_queries
        max_connections            = var.clickhouse_config.max_connections
        max_partition_size_to_drop = var.clickhouse_config.max_partition_size_to_drop
        max_table_size_to_drop     = var.clickhouse_config.max_table_size_to_drop

        dynamic "merge_tree" {
          for_each = range(var.clickhouse_config.merge_tree == null ? 0 : 1)
          content {
            max_bytes_to_merge_at_min_space_in_pool                   = var.clickhouse_config.merge_tree.max_bytes_to_merge_at_min_space_in_pool
            max_replicated_merges_in_queue                            = var.clickhouse_config.merge_tree.max_replicated_merges_in_queue
            min_bytes_for_wide_part                                   = var.clickhouse_config.merge_tree.min_bytes_for_wide_part
            min_rows_for_wide_part                                    = var.clickhouse_config.merge_tree.min_rows_for_wide_part
            number_of_free_entries_in_pool_to_lower_max_size_of_merge = var.clickhouse_config.merge_tree.number_of_free_entries_in_pool_to_lower_max_size_of_merge
            parts_to_delay_insert                                     = var.clickhouse_config.merge_tree.parts_to_delay_insert
            parts_to_throw_insert                                     = var.clickhouse_config.merge_tree.parts_to_throw_insert
            replicated_deduplication_window                           = var.clickhouse_config.merge_tree.replicated_deduplication_window
            replicated_deduplication_window_seconds                   = var.clickhouse_config.merge_tree.replicated_deduplication_window_seconds
            ttl_only_drop_parts                                       = var.clickhouse_config.merge_tree.ttl_only_drop_parts
          }
        }

        metric_log_enabled              = var.clickhouse_config.metric_log_enabled
        metric_log_retention_size       = var.clickhouse_config.metric_log_retention_size
        metric_log_retention_time       = var.clickhouse_config.metric_log_retention_time
        part_log_retention_size         = var.clickhouse_config.part_log_retention_size
        part_log_retention_time         = var.clickhouse_config.part_log_retention_time
        query_log_retention_size        = var.clickhouse_config.query_log_retention_size
        query_log_retention_time        = var.clickhouse_config.query_log_retention_time
        query_thread_log_enabled        = var.clickhouse_config.query_thread_log_enabled
        query_thread_log_retention_size = var.clickhouse_config.query_thread_log_retention_size
        query_thread_log_retention_time = var.clickhouse_config.query_thread_log_retention_time

        dynamic "rabbitmq" {
          for_each = range(var.clickhouse_config.rabbitmq == null ? 0 : 1)
          content {
            username = var.clickhouse_config.rabbitmq.username
            password = var.clickhouse_config.rabbitmq.password
            vhost    = var.clickhouse_config.rabbitmq.vhost
          }
        }

        text_log_enabled           = var.clickhouse_config.text_log_enabled
        text_log_level             = var.clickhouse_config.text_log_level
        text_log_retention_size    = var.clickhouse_config.text_log_retention_size
        text_log_retention_time    = var.clickhouse_config.text_log_retention_time
        timezone                   = var.clickhouse_config.timezone
        total_memory_profiler_step = var.clickhouse_config.total_memory_profiler_step
        trace_log_enabled          = var.clickhouse_config.trace_log_enabled
        trace_log_retention_size   = var.clickhouse_config.trace_log_retention_size
        trace_log_retention_time   = var.clickhouse_config.trace_log_retention_time
        uncompressed_cache_size    = var.clickhouse_config.uncompressed_cache_size
      }
    }
  }

  admin_password           = var.admin_password
  sql_user_management      = var.sql_user_management
  sql_database_management  = var.sql_database_management
  embedded_keeper          = var.embedded_keeper
  copy_schema_on_new_hosts = var.copy_schema_on_new_hosts

  zookeeper {
    resources {
      disk_size          = var.zookeeper_disk_size
      disk_type_id       = var.zookeeper_disk_type_id
      resource_preset_id = var.zookeeper_resource_preset_id
    }
  }

  dynamic "access" {
    for_each = range(var.access == null ? 0 : 1)
    content {
      data_lens     = var.access.data_lens
      metrika       = var.access.metrika
      web_sql       = var.access.web_sql
      serverless    = var.access.serverless
      yandex_query  = var.access.yandex_query
      data_transfer = var.access.data_transfer
    }
  }

  dynamic "backup_window_start" {
    for_each = range(var.backup_window_start == null ? 0 : 1)
    content {
      hours   = var.backup_window_start.hours
      minutes = var.backup_window_start.minutes
    }
  }

  dynamic "user" {
    for_each = var.users
    content {
      name     = user.value.name
      password = user.value.password == null ? random_password.password[user.value.name].result : user.value.password
      dynamic "quota" {
        for_each = user.value.quota
        content {
          interval_duration = quota.value.interval_duration
          queries           = quota.value.queries
          errors            = quota.value.errors
          result_rows       = quota.value.result_rows
          read_rows         = quota.value.read_rows
          execution_time    = quota.value.execution_time
        }
      }

      dynamic "permission" {
        for_each = user.value.permission
        content {
          database_name = permission.value.database_name
        }
      }

      dynamic "settings" {
        for_each = range(user.value.settings == null ? 0 : 1)
        content {
          add_http_cors_header                               = user.value.settings.add_http_cors_header
          allow_ddl                                          = user.value.settings.allow_ddl
          allow_introspection_functions                      = user.value.settings.allow_introspection_functions
          allow_suspicious_low_cardinality_types             = user.value.settings.allow_suspicious_low_cardinality_types
          async_insert                                       = user.value.settings.async_insert
          async_insert_busy_timeout                          = user.value.settings.async_insert_busy_timeout
          async_insert_max_data_size                         = user.value.settings.async_insert_max_data_size
          async_insert_stale_timeout                         = user.value.settings.async_insert_stale_timeout
          async_insert_threads                               = user.value.settings.async_insert_threads
          cancel_http_readonly_queries_on_client_close       = user.value.settings.cancel_http_readonly_queries_on_client_close
          compile                                            = user.value.settings.compile
          compile_expressions                                = user.value.settings.compile_expressions
          connect_timeout                                    = user.value.settings.connect_timeout
          connect_timeout_with_failover                      = user.value.settings.connect_timeout_with_failover
          count_distinct_implementation                      = user.value.settings.count_distinct_implementation
          distinct_overflow_mode                             = user.value.settings.distinct_overflow_mode
          distributed_aggregation_memory_efficient           = user.value.settings.distributed_aggregation_memory_efficient
          distributed_ddl_task_timeout                       = user.value.settings.distributed_ddl_task_timeout
          distributed_product_mode                           = user.value.settings.distributed_product_mode
          empty_result_for_aggregation_by_empty_set          = user.value.settings.empty_result_for_aggregation_by_empty_set
          enable_http_compression                            = user.value.settings.enable_http_compression
          fallback_to_stale_replicas_for_distributed_queries = user.value.settings.fallback_to_stale_replicas_for_distributed_queries
          flatten_nested                                     = user.value.settings.flatten_nested
          force_index_by_date                                = user.value.settings.force_index_by_date
          force_primary_key                                  = user.value.settings.force_primary_key
          group_by_overflow_mode                             = user.value.settings.group_by_overflow_mode
          group_by_two_level_threshold                       = user.value.settings.group_by_two_level_threshold
          group_by_two_level_threshold_bytes                 = user.value.settings.group_by_two_level_threshold_bytes
          http_connection_timeout                            = user.value.settings.http_connection_timeout
          http_headers_progress_interval                     = user.value.settings.http_headers_progress_interval
          http_receive_timeout                               = user.value.settings.http_receive_timeout
          http_send_timeout                                  = user.value.settings.http_send_timeout
          input_format_defaults_for_omitted_fields           = user.value.settings.input_format_defaults_for_omitted_fields
          input_format_values_interpret_expressions          = user.value.settings.input_format_values_interpret_expressions
          insert_null_as_default                             = user.value.settings.insert_null_as_default
          insert_quorum                                      = user.value.settings.insert_quorum
          insert_quorum_timeout                              = user.value.settings.insert_quorum_timeout
          join_overflow_mode                                 = user.value.settings.join_overflow_mode
          join_use_nulls                                     = user.value.settings.join_use_nulls
          joined_subquery_requires_alias                     = user.value.settings.joined_subquery_requires_alias
          low_cardinality_allow_in_native_format             = user.value.settings.low_cardinality_allow_in_native_format
          max_ast_depth                                      = user.value.settings.max_ast_depth
          max_ast_elements                                   = user.value.settings.max_ast_elements
          max_block_size                                     = user.value.settings.max_block_size
          max_bytes_before_external_group_by                 = user.value.settings.max_bytes_before_external_group_by
          max_bytes_before_external_sort                     = user.value.settings.max_bytes_before_external_sort
          max_bytes_in_distinct                              = user.value.settings.max_bytes_in_distinct
          max_bytes_in_join                                  = user.value.settings.max_bytes_in_join
          max_bytes_in_set                                   = user.value.settings.max_bytes_in_set
          max_bytes_to_read                                  = user.value.settings.max_bytes_to_read
          max_bytes_to_sort                                  = user.value.settings.max_bytes_to_sort
          max_bytes_to_transfer                              = user.value.settings.max_bytes_to_transfer
          max_columns_to_read                                = user.value.settings.max_columns_to_read
          max_concurrent_queries_for_user                    = user.value.settings.max_concurrent_queries_for_user
          max_execution_time                                 = user.value.settings.max_execution_time
          max_expanded_ast_elements                          = user.value.settings.max_expanded_ast_elements
          max_http_get_redirects                             = user.value.settings.max_http_get_redirects
          max_insert_block_size                              = user.value.settings.max_insert_block_size
          max_memory_usage                                   = user.value.settings.max_memory_usage
          max_memory_usage_for_user                          = user.value.settings.max_memory_usage_for_user
          max_network_bandwidth                              = user.value.settings.max_network_bandwidth
          max_network_bandwidth_for_user                     = user.value.settings.max_network_bandwidth_for_user
          max_query_size                                     = user.value.settings.max_query_size
          max_replica_delay_for_distributed_queries          = user.value.settings.max_replica_delay_for_distributed_queries
          max_result_bytes                                   = user.value.settings.max_result_bytes
          max_result_rows                                    = user.value.settings.max_result_rows
          max_rows_in_distinct                               = user.value.settings.max_rows_in_distinct
          max_rows_in_join                                   = user.value.settings.max_rows_in_join
          max_rows_in_set                                    = user.value.settings.max_rows_in_set
          max_rows_to_group_by                               = user.value.settings.max_rows_to_group_by
          max_rows_to_read                                   = user.value.settings.max_rows_to_read
          max_rows_to_sort                                   = user.value.settings.max_rows_to_sort
          max_rows_to_transfer                               = user.value.settings.max_rows_to_transfer
          max_temporary_columns                              = user.value.settings.max_temporary_columns
          max_temporary_non_const_columns                    = user.value.settings.max_temporary_non_const_columns
          max_threads                                        = user.value.settings.max_threads
          memory_profiler_sample_probability                 = user.value.settings.memory_profiler_sample_probability
          memory_profiler_step                               = user.value.settings.memory_profiler_step
          merge_tree_max_bytes_to_use_cache                  = user.value.settings.merge_tree_max_bytes_to_use_cache
          merge_tree_max_rows_to_use_cache                   = user.value.settings.merge_tree_max_rows_to_use_cache
          merge_tree_min_bytes_for_concurrent_read           = user.value.settings.merge_tree_min_bytes_for_concurrent_read
          merge_tree_min_rows_for_concurrent_read            = user.value.settings.merge_tree_min_rows_for_concurrent_read
          min_bytes_to_use_direct_io                         = user.value.settings.min_bytes_to_use_direct_io
          min_count_to_compile                               = user.value.settings.min_count_to_compile
          min_count_to_compile_expression                    = user.value.settings.min_count_to_compile_expression
          min_execution_speed                                = user.value.settings.min_execution_speed
          min_execution_speed_bytes                          = user.value.settings.min_execution_speed_bytes
          min_insert_block_size_bytes                        = user.value.settings.min_insert_block_size_bytes
          min_insert_block_size_rows                         = user.value.settings.min_insert_block_size_rows
          output_format_json_quote_64bit_integers            = user.value.settings.output_format_json_quote_64bit_integers
          output_format_json_quote_denormals                 = user.value.settings.output_format_json_quote_denormals
          priority                                           = user.value.settings.priority
          quota_mode                                         = user.value.settings.quota_mode
          read_overflow_mode                                 = user.value.settings.read_overflow_mode
          readonly                                           = user.value.settings.readonly
          receive_timeout                                    = user.value.settings.receive_timeout
          replication_alter_partitions_sync                  = user.value.settings.replication_alter_partitions_sync
          result_overflow_mode                               = user.value.settings.result_overflow_mode
          select_sequential_consistency                      = user.value.settings.select_sequential_consistency
          send_progress_in_http_headers                      = user.value.settings.send_progress_in_http_headers
          send_timeout                                       = user.value.settings.send_timeout
          set_overflow_mode                                  = user.value.settings.set_overflow_mode
          skip_unavailable_shards                            = user.value.settings.skip_unavailable_shards
          sort_overflow_mode                                 = user.value.settings.sort_overflow_mode
          timeout_before_checking_execution_speed            = user.value.settings.timeout_before_checking_execution_speed
          timeout_overflow_mode                              = user.value.settings.timeout_overflow_mode
          transfer_overflow_mode                             = user.value.settings.transfer_overflow_mode
          transform_null_in                                  = user.value.settings.transform_null_in
          use_uncompressed_cache                             = user.value.settings.use_uncompressed_cache
          wait_for_async_insert                              = user.value.settings.wait_for_async_insert
          wait_for_async_insert_timeout                      = user.value.settings.wait_for_async_insert_timeout
        }
      }
    }
  }

  dynamic "host" {
    for_each = var.hosts
    content {
      type             = host.value.type
      zone             = host.value.zone
      subnet_id        = host.value.subnet_id
      shard_name       = host.value.shard_name
      assign_public_ip = host.value.assign_public_ip
    }
  }

  dynamic "shard" {
    for_each = var.shards
    content {
      name   = shard.value.name
      weight = shard.value.weight
      dynamic "resources" {
        for_each = range(shard.value.resources == null ? 0 : 1)
        content {
          resource_preset_id = shard.value.resources.resource_preset_id
          disk_size          = shard.value.resources.disk_size
          disk_type_id       = shard.value.resources.disk_type_id
        }
      }
    }
  }

  dynamic "database" {
    for_each = var.databases
    content {
      name = database.value.name
    }
  }

  dynamic "maintenance_window" {
    for_each = range(var.maintenance_window == null ? 0 : 1)
    content {
      type = var.maintenance_window.type
      day  = var.maintenance_window.day
      hour = var.maintenance_window.hour
    }
  }

  dynamic "ml_model" {
    for_each = range(var.ml_model == null ? 0 : 1)
    content {
      name = var.ml_model.name
      type = var.ml_model.type
      uri  = var.ml_model.uri
    }
  }

  dynamic "format_schema" {
    for_each = range(var.format_schema == null ? 0 : 1)
    content {
      name = var.format_schema.name
      type = var.format_schema.type
      uri  = var.format_schema.uri
    }
  }

  dynamic "cloud_storage" {
    for_each = range(var.cloud_storage == null ? 0 : 1)
    content {
      enabled             = var.cloud_storage.enabled
      move_factor         = var.cloud_storage.move_factor
      data_cache_enabled  = var.cloud_storage.data_cache_enabled
      data_cache_max_size = var.cloud_storage.data_cache_max_size
    }
  }

  dynamic "shard_group" {
    for_each = range(var.shard_group == null ? 0 : 1)
    content {
      name        = var.shard_group.name
      shard_names = var.shard_group.shard_names
      description = var.shard_group.description
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

}

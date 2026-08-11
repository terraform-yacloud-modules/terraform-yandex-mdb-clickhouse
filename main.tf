data "yandex_client_config" "client" {}

locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id

  # Build password map from Lockbox if secret_id provided, otherwise empty
  lockbox_passwords = var.lockbox_secret_id != null ? {
    for entry in data.yandex_lockbox_secret_version.ch_passwords[0].entries :
    entry.key => entry.text_value
  } : {}
}

data "yandex_lockbox_secret_version" "ch_passwords" {
  count     = var.lockbox_secret_id != null ? 1 : 0
  secret_id = var.lockbox_secret_id
}

resource "random_password" "password" {
  # Only generate random password if user has no password in Lockbox and no explicit password
  for_each         = { for v in var.users : v.name => v if v.password == null && !contains(keys(local.lockbox_passwords), v.name) }
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

  version                   = var.clickhouse_version
  folder_id                 = local.folder_id
  labels                    = var.labels
  security_group_ids        = var.security_group_ids
  deletion_protection       = var.deletion_protection
  description               = var.description
  backup_retain_period_days = var.backup_retain_period_days
  disk_encryption_key_id    = var.disk_encryption_key_id
  cluster_id                = var.cluster_id
  service_account_id        = var.service_account_id

  clickhouse {
    resources {
      disk_size          = var.clickhouse_disk_size
      disk_type_id       = var.clickhouse_disk_type_id
      resource_preset_id = var.clickhouse_resource_preset_id
    }
    dynamic "config" {
      for_each = range(var.clickhouse_config == null ? 0 : 1)
      content {
        background_buffer_flush_schedule_pool_size    = var.clickhouse_config.background_buffer_flush_schedule_pool_size
        background_common_pool_size                   = var.clickhouse_config.background_common_pool_size
        background_distributed_schedule_pool_size     = var.clickhouse_config.background_distributed_schedule_pool_size
        background_fetches_pool_size                  = var.clickhouse_config.background_fetches_pool_size
        background_merges_mutations_concurrency_ratio = var.clickhouse_config.background_merges_mutations_concurrency_ratio
        background_message_broker_schedule_pool_size  = var.clickhouse_config.background_message_broker_schedule_pool_size
        background_move_pool_size                     = var.clickhouse_config.background_move_pool_size
        background_pool_size                          = var.clickhouse_config.background_pool_size
        background_schedule_pool_size                 = var.clickhouse_config.background_schedule_pool_size

        dynamic "compression" {
          for_each = range(var.clickhouse_config.compression == null ? 0 : 1)
          content {
            method              = var.clickhouse_config.compression.method
            min_part_size       = var.clickhouse_config.compression.min_part_size
            min_part_size_ratio = var.clickhouse_config.compression.min_part_size_ratio
            level               = var.clickhouse_config.compression.level
          }
        }

        default_database       = var.clickhouse_config.default_database
        dictionaries_lazy_load = var.clickhouse_config.dictionaries_lazy_load
        geobase_enabled        = var.clickhouse_config.geobase_enabled
        geobase_uri            = var.clickhouse_config.geobase_uri

        dynamic "graphite_rollup" {
          for_each = range(var.clickhouse_config.graphite_rollup == null ? 0 : 1)
          content {
            name                = var.clickhouse_config.graphite_rollup.name
            path_column_name    = var.clickhouse_config.graphite_rollup.path_column_name
            time_column_name    = var.clickhouse_config.graphite_rollup.time_column_name
            value_column_name   = var.clickhouse_config.graphite_rollup.value_column_name
            version_column_name = var.clickhouse_config.graphite_rollup.version_column_name
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
            auto_offset_reset                   = var.clickhouse_config.kafka.auto_offset_reset
            debug                               = var.clickhouse_config.kafka.debug
            enable_ssl_certificate_verification = var.clickhouse_config.kafka.enable_ssl_certificate_verification
            max_poll_interval_ms                = var.clickhouse_config.kafka.max_poll_interval_ms
            security_protocol                   = var.clickhouse_config.kafka.security_protocol
            sasl_mechanism                      = var.clickhouse_config.kafka.sasl_mechanism
            sasl_username                       = var.clickhouse_config.kafka.sasl_username
            sasl_password                       = var.clickhouse_config.kafka.sasl_password
            session_timeout_ms                  = var.clickhouse_config.kafka.session_timeout_ms
          }
        }

        dynamic "kafka_topic" {
          for_each = range(var.clickhouse_config.kafka_topic == null ? 0 : 1)
          content {
            name = var.clickhouse_config.kafka_topic.name
            dynamic "settings" {
              for_each = range(var.clickhouse_config.kafka_topic.settings == null ? 0 : 1)
              content {
                auto_offset_reset                   = var.clickhouse_config.kafka_topic.settings.auto_offset_reset
                debug                               = var.clickhouse_config.kafka_topic.settings.debug
                enable_ssl_certificate_verification = var.clickhouse_config.kafka_topic.settings.enable_ssl_certificate_verification
                max_poll_interval_ms                = var.clickhouse_config.kafka_topic.settings.max_poll_interval_ms
                security_protocol                   = var.clickhouse_config.kafka_topic.settings.security_protocol
                sasl_mechanism                      = var.clickhouse_config.kafka_topic.settings.sasl_mechanism
                sasl_username                       = var.clickhouse_config.kafka_topic.settings.sasl_username
                sasl_password                       = var.clickhouse_config.kafka_topic.settings.sasl_password
                session_timeout_ms                  = var.clickhouse_config.kafka_topic.settings.session_timeout_ms
              }
            }
          }
        }

        dynamic "jdbc_bridge" {
          for_each = range(var.clickhouse_config.jdbc_bridge == null ? 0 : 1)
          content {
            host = var.clickhouse_config.jdbc_bridge.host
            port = var.clickhouse_config.jdbc_bridge.port
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
            allow_remote_fs_zero_copy_replication                     = var.clickhouse_config.merge_tree.allow_remote_fs_zero_copy_replication
            check_sample_column_is_correct                            = var.clickhouse_config.merge_tree.check_sample_column_is_correct
            cleanup_delay_period                                      = var.clickhouse_config.merge_tree.cleanup_delay_period
            inactive_parts_to_delay_insert                            = var.clickhouse_config.merge_tree.inactive_parts_to_delay_insert
            inactive_parts_to_throw_insert                            = var.clickhouse_config.merge_tree.inactive_parts_to_throw_insert
            max_avg_part_size_for_too_many_parts                      = var.clickhouse_config.merge_tree.max_avg_part_size_for_too_many_parts
            max_bytes_to_merge_at_max_space_in_pool                   = var.clickhouse_config.merge_tree.max_bytes_to_merge_at_max_space_in_pool
            max_bytes_to_merge_at_min_space_in_pool                   = var.clickhouse_config.merge_tree.max_bytes_to_merge_at_min_space_in_pool
            max_cleanup_delay_period                                  = var.clickhouse_config.merge_tree.max_cleanup_delay_period
            max_merge_selecting_sleep_ms                              = var.clickhouse_config.merge_tree.max_merge_selecting_sleep_ms
            max_number_of_merges_with_ttl_in_pool                     = var.clickhouse_config.merge_tree.max_number_of_merges_with_ttl_in_pool
            max_parts_in_total                                        = var.clickhouse_config.merge_tree.max_parts_in_total
            max_replicated_merges_in_queue                            = var.clickhouse_config.merge_tree.max_replicated_merges_in_queue
            merge_max_block_size                                      = var.clickhouse_config.merge_tree.merge_max_block_size
            merge_selecting_sleep_ms                                  = var.clickhouse_config.merge_tree.merge_selecting_sleep_ms
            merge_with_recompression_ttl_timeout                      = var.clickhouse_config.merge_tree.merge_with_recompression_ttl_timeout
            merge_with_ttl_timeout                                    = var.clickhouse_config.merge_tree.merge_with_ttl_timeout
            min_age_to_force_merge_on_partition_only                  = var.clickhouse_config.merge_tree.min_age_to_force_merge_on_partition_only
            min_age_to_force_merge_seconds                            = var.clickhouse_config.merge_tree.min_age_to_force_merge_seconds
            min_bytes_for_wide_part                                   = var.clickhouse_config.merge_tree.min_bytes_for_wide_part
            min_rows_for_wide_part                                    = var.clickhouse_config.merge_tree.min_rows_for_wide_part
            number_of_free_entries_in_pool_to_execute_mutation        = var.clickhouse_config.merge_tree.number_of_free_entries_in_pool_to_execute_mutation
            number_of_free_entries_in_pool_to_lower_max_size_of_merge = var.clickhouse_config.merge_tree.number_of_free_entries_in_pool_to_lower_max_size_of_merge
            parts_to_delay_insert                                     = var.clickhouse_config.merge_tree.parts_to_delay_insert
            parts_to_throw_insert                                     = var.clickhouse_config.merge_tree.parts_to_throw_insert
            replicated_deduplication_window                           = var.clickhouse_config.merge_tree.replicated_deduplication_window
            replicated_deduplication_window_seconds                   = var.clickhouse_config.merge_tree.replicated_deduplication_window_seconds
            ttl_only_drop_parts                                       = var.clickhouse_config.merge_tree.ttl_only_drop_parts
          }
        }

        metric_log_enabled                     = var.clickhouse_config.metric_log_enabled
        metric_log_retention_size              = var.clickhouse_config.metric_log_retention_size
        metric_log_retention_time              = var.clickhouse_config.metric_log_retention_time
        opentelemetry_span_log_enabled         = var.clickhouse_config.opentelemetry_span_log_enabled
        opentelemetry_span_log_retention_size  = var.clickhouse_config.opentelemetry_span_log_retention_size
        opentelemetry_span_log_retention_time  = var.clickhouse_config.opentelemetry_span_log_retention_time
        part_log_retention_size                = var.clickhouse_config.part_log_retention_size
        part_log_retention_time                = var.clickhouse_config.part_log_retention_time
        query_log_retention_size               = var.clickhouse_config.query_log_retention_size
        query_log_retention_time               = var.clickhouse_config.query_log_retention_time
        query_thread_log_enabled               = var.clickhouse_config.query_thread_log_enabled
        query_thread_log_retention_size        = var.clickhouse_config.query_thread_log_retention_size
        query_thread_log_retention_time        = var.clickhouse_config.query_thread_log_retention_time
        query_views_log_enabled                = var.clickhouse_config.query_views_log_enabled
        query_views_log_retention_size         = var.clickhouse_config.query_views_log_retention_size
        query_views_log_retention_time         = var.clickhouse_config.query_views_log_retention_time
        session_log_enabled                    = var.clickhouse_config.session_log_enabled
        session_log_retention_size             = var.clickhouse_config.session_log_retention_size
        session_log_retention_time             = var.clickhouse_config.session_log_retention_time
        asynchronous_insert_log_enabled        = var.clickhouse_config.asynchronous_insert_log_enabled
        asynchronous_insert_log_retention_size = var.clickhouse_config.asynchronous_insert_log_retention_size
        asynchronous_insert_log_retention_time = var.clickhouse_config.asynchronous_insert_log_retention_time
        asynchronous_metric_log_enabled        = var.clickhouse_config.asynchronous_metric_log_enabled
        asynchronous_metric_log_retention_size = var.clickhouse_config.asynchronous_metric_log_retention_size
        asynchronous_metric_log_retention_time = var.clickhouse_config.asynchronous_metric_log_retention_time
        zookeeper_log_enabled                  = var.clickhouse_config.zookeeper_log_enabled
        zookeeper_log_retention_size           = var.clickhouse_config.zookeeper_log_retention_size
        zookeeper_log_retention_time           = var.clickhouse_config.zookeeper_log_retention_time

        dynamic "query_cache" {
          for_each = range(var.clickhouse_config.query_cache == null ? 0 : 1)
          content {
            max_entries             = var.clickhouse_config.query_cache.max_entries
            max_entry_size_in_bytes = var.clickhouse_config.query_cache.max_entry_size_in_bytes
            max_entry_size_in_rows  = var.clickhouse_config.query_cache.max_entry_size_in_rows
            max_size_in_bytes       = var.clickhouse_config.query_cache.max_size_in_bytes
          }
        }

        dynamic "query_masking_rules" {
          for_each = var.clickhouse_config.query_masking_rules
          content {
            name    = query_masking_rules.value.name
            regexp  = query_masking_rules.value.regexp
            replace = query_masking_rules.value.replace
          }
        }

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
      prefer_not_to_merge = var.cloud_storage.prefer_not_to_merge
    }
  }

  dynamic "shard_group" {
    for_each = range(var.shard_group == null ? 0 : 1)
    content {
      name        = var.shard_group.name
      description = var.shard_group.description
      shard_names = var.shard_group.shard_names
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

  lifecycle {
    # Ignore inline database/user blocks — managed via separate resources below
    ignore_changes = [database, user]
  }
}

# ClickHouse databases
resource "yandex_mdb_clickhouse_database" "dbs" {
  for_each = { for db in var.databases : db.name => db }

  cluster_id = yandex_mdb_clickhouse_cluster.this.id
  name       = each.value.name

  depends_on = [yandex_mdb_clickhouse_cluster.this]
}

# ClickHouse users
resource "yandex_mdb_clickhouse_user" "users" {
  for_each = { for u in var.users : u.name => u }

  cluster_id = yandex_mdb_clickhouse_cluster.this.id
  name       = each.value.name

  # Password priority: Lockbox > explicit password > random
  password = (
    contains(keys(local.lockbox_passwords), each.value.name)
    ? local.lockbox_passwords[each.value.name]
    : each.value.password != null
      ? each.value.password
      : random_password.password[each.key].result
  )

  dynamic "quota" {
    for_each = each.value.quota
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
    for_each = each.value.permission
    content {
      database_name = permission.value.database_name
    }
  }

  dynamic "settings" {
    for_each = each.value.settings != null ? [each.value.settings] : []
    content {
      add_http_cors_header                               = settings.value.add_http_cors_header
      allow_ddl                                          = settings.value.allow_ddl
      allow_introspection_functions                      = settings.value.allow_introspection_functions
      allow_suspicious_low_cardinality_types             = settings.value.allow_suspicious_low_cardinality_types
      async_insert                                       = settings.value.async_insert
      async_insert_busy_timeout                          = settings.value.async_insert_busy_timeout
      async_insert_max_data_size                         = settings.value.async_insert_max_data_size
      async_insert_stale_timeout                         = settings.value.async_insert_stale_timeout
      async_insert_threads                               = settings.value.async_insert_threads
      cancel_http_readonly_queries_on_client_close       = settings.value.cancel_http_readonly_queries_on_client_close
      compile_expressions                                = settings.value.compile_expressions
      connect_timeout                                    = settings.value.connect_timeout
      connect_timeout_with_failover                      = settings.value.connect_timeout_with_failover
      count_distinct_implementation                      = settings.value.count_distinct_implementation
      distinct_overflow_mode                             = settings.value.distinct_overflow_mode
      distributed_aggregation_memory_efficient           = settings.value.distributed_aggregation_memory_efficient
      distributed_ddl_task_timeout                       = settings.value.distributed_ddl_task_timeout
      distributed_product_mode                           = settings.value.distributed_product_mode
      empty_result_for_aggregation_by_empty_set          = settings.value.empty_result_for_aggregation_by_empty_set
      enable_http_compression                            = settings.value.enable_http_compression
      fallback_to_stale_replicas_for_distributed_queries = settings.value.fallback_to_stale_replicas_for_distributed_queries
      flatten_nested                                     = settings.value.flatten_nested
      force_index_by_date                                = settings.value.force_index_by_date
      force_primary_key                                  = settings.value.force_primary_key
      group_by_overflow_mode                             = settings.value.group_by_overflow_mode
      group_by_two_level_threshold                       = settings.value.group_by_two_level_threshold
      group_by_two_level_threshold_bytes                 = settings.value.group_by_two_level_threshold_bytes
      http_connection_timeout                            = settings.value.http_connection_timeout
      http_headers_progress_interval                     = settings.value.http_headers_progress_interval
      http_receive_timeout                               = settings.value.http_receive_timeout
      http_send_timeout                                  = settings.value.http_send_timeout
      input_format_defaults_for_omitted_fields           = settings.value.input_format_defaults_for_omitted_fields
      input_format_values_interpret_expressions          = settings.value.input_format_values_interpret_expressions
      insert_null_as_default                             = settings.value.insert_null_as_default
      insert_quorum                                      = settings.value.insert_quorum
      insert_quorum_timeout                              = settings.value.insert_quorum_timeout
      join_overflow_mode                                 = settings.value.join_overflow_mode
      join_use_nulls                                     = settings.value.join_use_nulls
      joined_subquery_requires_alias                     = settings.value.joined_subquery_requires_alias
      low_cardinality_allow_in_native_format             = settings.value.low_cardinality_allow_in_native_format
      max_ast_depth                                      = settings.value.max_ast_depth
      max_ast_elements                                   = settings.value.max_ast_elements
      max_block_size                                     = settings.value.max_block_size
      max_bytes_before_external_group_by                 = settings.value.max_bytes_before_external_group_by
      max_bytes_before_external_sort                     = settings.value.max_bytes_before_external_sort
      max_bytes_in_distinct                              = settings.value.max_bytes_in_distinct
      max_bytes_in_join                                  = settings.value.max_bytes_in_join
      max_bytes_in_set                                   = settings.value.max_bytes_in_set
      max_bytes_to_read                                  = settings.value.max_bytes_to_read
      max_bytes_to_sort                                  = settings.value.max_bytes_to_sort
      max_bytes_to_transfer                              = settings.value.max_bytes_to_transfer
      max_columns_to_read                                = settings.value.max_columns_to_read
      max_concurrent_queries_for_user                    = settings.value.max_concurrent_queries_for_user
      max_execution_time                                 = settings.value.max_execution_time
      max_expanded_ast_elements                          = settings.value.max_expanded_ast_elements
      max_http_get_redirects                             = settings.value.max_http_get_redirects
      max_insert_block_size                              = settings.value.max_insert_block_size
      max_memory_usage                                   = settings.value.max_memory_usage
      max_memory_usage_for_user                          = settings.value.max_memory_usage_for_user
      max_network_bandwidth                              = settings.value.max_network_bandwidth
      max_network_bandwidth_for_user                     = settings.value.max_network_bandwidth_for_user
      max_query_size                                     = settings.value.max_query_size
      max_replica_delay_for_distributed_queries          = settings.value.max_replica_delay_for_distributed_queries
      max_result_bytes                                   = settings.value.max_result_bytes
      max_result_rows                                    = settings.value.max_result_rows
      max_rows_in_distinct                               = settings.value.max_rows_in_distinct
      max_rows_in_join                                   = settings.value.max_rows_in_join
      max_rows_in_set                                    = settings.value.max_rows_in_set
      max_rows_to_group_by                               = settings.value.max_rows_to_group_by
      max_rows_to_read                                   = settings.value.max_rows_to_read
      max_rows_to_sort                                   = settings.value.max_rows_to_sort
      max_rows_to_transfer                               = settings.value.max_rows_to_transfer
      max_temporary_columns                              = settings.value.max_temporary_columns
      max_temporary_non_const_columns                    = settings.value.max_temporary_non_const_columns
      max_threads                                        = settings.value.max_threads
      memory_profiler_sample_probability                 = settings.value.memory_profiler_sample_probability
      memory_profiler_step                               = settings.value.memory_profiler_step
      merge_tree_max_bytes_to_use_cache                  = settings.value.merge_tree_max_bytes_to_use_cache
      merge_tree_max_rows_to_use_cache                   = settings.value.merge_tree_max_rows_to_use_cache
      merge_tree_min_bytes_for_concurrent_read           = settings.value.merge_tree_min_bytes_for_concurrent_read
      merge_tree_min_rows_for_concurrent_read            = settings.value.merge_tree_min_rows_for_concurrent_read
      min_bytes_to_use_direct_io                         = settings.value.min_bytes_to_use_direct_io
      min_count_to_compile_expression                    = settings.value.min_count_to_compile_expression
      min_execution_speed                                = settings.value.min_execution_speed
      min_execution_speed_bytes                          = settings.value.min_execution_speed_bytes
      min_insert_block_size_bytes                        = settings.value.min_insert_block_size_bytes
      min_insert_block_size_rows                         = settings.value.min_insert_block_size_rows
      output_format_json_quote_64bit_integers            = settings.value.output_format_json_quote_64bit_integers
      output_format_json_quote_denormals                 = settings.value.output_format_json_quote_denormals
      priority                                           = settings.value.priority
      quota_mode                                         = settings.value.quota_mode
      read_overflow_mode                                 = settings.value.read_overflow_mode
      readonly                                           = settings.value.readonly
      receive_timeout                                    = settings.value.receive_timeout
      replication_alter_partitions_sync                  = settings.value.replication_alter_partitions_sync
      result_overflow_mode                               = settings.value.result_overflow_mode
      select_sequential_consistency                      = settings.value.select_sequential_consistency
      send_progress_in_http_headers                      = settings.value.send_progress_in_http_headers
      send_timeout                                       = settings.value.send_timeout
      set_overflow_mode                                  = settings.value.set_overflow_mode
      skip_unavailable_shards                            = settings.value.skip_unavailable_shards
      sort_overflow_mode                                 = settings.value.sort_overflow_mode
      timeout_before_checking_execution_speed            = settings.value.timeout_before_checking_execution_speed
      timeout_overflow_mode                              = settings.value.timeout_overflow_mode
      transfer_overflow_mode                             = settings.value.transfer_overflow_mode
      transform_null_in                                  = settings.value.transform_null_in
      use_uncompressed_cache                             = settings.value.use_uncompressed_cache
      wait_for_async_insert                              = settings.value.wait_for_async_insert
      wait_for_async_insert_timeout                      = settings.value.wait_for_async_insert_timeout
    }
  }

  depends_on = [yandex_mdb_clickhouse_database.dbs]
}

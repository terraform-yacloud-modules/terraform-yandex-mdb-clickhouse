# Variables
# Documentation: https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_clickhouse_cluster

# Required

variable "network_id" {
  description = "(Required) ClickHouse cluster network id"
  type        = string
}

variable "users" {
  description = <<EOF
    (Required) This is a list for additional ClickHouse users with own permissions.

    Required values:
      - name                - The name of the user.
      - password            - The user's password. If it's omitted a random password will be generated

    Optional values:
      - permission          - Set of permissions granted to the user. .
        - database_name     - (Required) The name of the database that the permission grants access to.
      - settings            - Custom settings for user. The list is documented below.
                              All options by link: https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_clickhouse_cluster#settings
      - quota               - Set of user quotas. .
        - interval_duration - (Required) Duration of interval for quota in milliseconds.
        - queries           - (Optional) The total number of queries.
        - errors            - (Optional) The number of queries that threw exception.
        - result_rows       - (Optional) The total number of rows given as the result.
        - read_rows         - (Optional) The total number of source rows read from tables for running the query, on all remote servers.
        - execution_time    - (Optional) The total query execution time, in milliseconds (wall time).
  EOF

  type = list(object({
    name     = string
    password = optional(string)
    quota = optional(list(object({
      interval_duration = string
      queries           = optional(number, null)
      errors            = optional(number, null)
      result_rows       = optional(number, null)
      read_rows         = optional(number, null)
      execution_time    = optional(number, null)
    })), [])
    permission = optional(list(object({
      database_name = string
    })), [])
    settings = optional(object({
      add_http_cors_header                               = optional(bool, false)
      allow_ddl                                          = optional(bool, false)
      allow_introspection_functions                      = optional(bool, false)
      allow_suspicious_low_cardinality_types             = optional(bool, false)
      async_insert                                       = optional(bool, false)
      async_insert_busy_timeout                          = optional(number, 0)
      async_insert_max_data_size                         = optional(number, 0)
      async_insert_stale_timeout                         = optional(number, 0)
      async_insert_threads                               = optional(number, 0)
      cancel_http_readonly_queries_on_client_close       = optional(bool, false)
      compile                                            = optional(bool, false)
      compile_expressions                                = optional(bool, false)
      connect_timeout                                    = optional(number, 0)
      connect_timeout_with_failover                      = optional(number, 0)
      count_distinct_implementation                      = optional(string, "unspecified")
      distinct_overflow_mode                             = optional(string, "unspecified")
      distributed_aggregation_memory_efficient           = optional(bool, false)
      distributed_ddl_task_timeout                       = optional(number, 0)
      distributed_product_mode                           = optional(string, "unspecified")
      empty_result_for_aggregation_by_empty_set          = optional(bool, false)
      enable_http_compression                            = optional(bool, false)
      fallback_to_stale_replicas_for_distributed_queries = optional(bool, false)
      flatten_nested                                     = optional(bool, false)
      force_index_by_date                                = optional(bool, false)
      force_primary_key                                  = optional(bool, false)
      group_by_overflow_mode                             = optional(string, "unspecified")
      group_by_two_level_threshold                       = optional(number, 0)
      group_by_two_level_threshold_bytes                 = optional(number, 0)
      http_connection_timeout                            = optional(number, 0)
      http_headers_progress_interval                     = optional(number, 0)
      http_receive_timeout                               = optional(number, 0)
      http_send_timeout                                  = optional(number, 0)
      input_format_defaults_for_omitted_fields           = optional(bool, false)
      input_format_values_interpret_expressions          = optional(bool, false)
      insert_null_as_default                             = optional(bool, false)
      insert_quorum                                      = optional(number, 0)
      insert_quorum_timeout                              = optional(number, 0)
      join_overflow_mode                                 = optional(string, "unspecified")
      join_use_nulls                                     = optional(bool, false)
      joined_subquery_requires_alias                     = optional(bool, false)
      low_cardinality_allow_in_native_format             = optional(bool, false)
      max_ast_depth                                      = optional(number, 0)
      max_ast_elements                                   = optional(number, 0)
      max_block_size                                     = optional(number, 0)
      max_bytes_before_external_group_by                 = optional(number, 0)
      max_bytes_before_external_sort                     = optional(number, 0)
      max_bytes_in_distinct                              = optional(number, 0)
      max_bytes_in_join                                  = optional(number, 0)
      max_bytes_in_set                                   = optional(number, 0)
      max_bytes_to_read                                  = optional(number, 0)
      max_bytes_to_sort                                  = optional(number, 0)
      max_bytes_to_transfer                              = optional(number, 0)
      max_columns_to_read                                = optional(number, 0)
      max_concurrent_queries_for_user                    = optional(number, 0)
      max_execution_time                                 = optional(number, 0)
      max_expanded_ast_elements                          = optional(number, 0)
      max_http_get_redirects                             = optional(number, 0)
      max_insert_block_size                              = optional(number, 0)
      max_memory_usage                                   = optional(number, 0)
      max_memory_usage_for_user                          = optional(number, 0)
      max_network_bandwidth                              = optional(number, 0)
      max_network_bandwidth_for_user                     = optional(number, 0)
      max_query_size                                     = optional(number, 0)
      max_replica_delay_for_distributed_queries          = optional(number, 0)
      max_result_bytes                                   = optional(number, 0)
      max_result_rows                                    = optional(number, 0)
      max_rows_in_distinct                               = optional(number, 0)
      max_rows_in_join                                   = optional(number, 0)
      max_rows_in_set                                    = optional(number, 0)
      max_rows_to_group_by                               = optional(number, 0)
      max_rows_to_read                                   = optional(number, 0)
      max_rows_to_sort                                   = optional(number, 0)
      max_rows_to_transfer                               = optional(number, 0)
      max_temporary_columns                              = optional(number, 0)
      max_temporary_non_const_columns                    = optional(number, 0)
      max_threads                                        = optional(number, 0)
      memory_profiler_sample_probability                 = optional(number, 0)
      memory_profiler_step                               = optional(number, 0)
      merge_tree_max_bytes_to_use_cache                  = optional(number, 0)
      merge_tree_max_rows_to_use_cache                   = optional(number, 0)
      merge_tree_min_bytes_for_concurrent_read           = optional(number, 0)
      merge_tree_min_rows_for_concurrent_read            = optional(number, 0)
      min_bytes_to_use_direct_io                         = optional(number, 0)
      min_count_to_compile                               = optional(number, 0)
      min_count_to_compile_expression                    = optional(number, 0)
      min_execution_speed                                = optional(number, 0)
      min_execution_speed_bytes                          = optional(number, 0)
      min_insert_block_size_bytes                        = optional(number, 0)
      min_insert_block_size_rows                         = optional(number, 0)
      output_format_json_quote_64bit_integers            = optional(bool, false)
      output_format_json_quote_denormals                 = optional(bool, false)
      priority                                           = optional(number, 0)
      quota_mode                                         = optional(string, "unspecified")
      read_overflow_mode                                 = optional(string, "unspecified")
      readonly                                           = optional(number, 0)
      receive_timeout                                    = optional(number, 0)
      replication_alter_partitions_sync                  = optional(number, 0)
      result_overflow_mode                               = optional(string, "unspecified")
      select_sequential_consistency                      = optional(bool, false)
      send_progress_in_http_headers                      = optional(bool, false)
      send_timeout                                       = optional(number, 0)
      set_overflow_mode                                  = optional(string, "unspecified")
      skip_unavailable_shards                            = optional(bool, false)
      sort_overflow_mode                                 = optional(string, "unspecified")
      timeout_before_checking_execution_speed            = optional(number, 0)
      timeout_overflow_mode                              = optional(string, "unspecified")
      transfer_overflow_mode                             = optional(string, "unspecified")
      transform_null_in                                  = optional(bool, false)
      use_uncompressed_cache                             = optional(bool, false)
      wait_for_async_insert                              = optional(bool, false)
      wait_for_async_insert_timeout                      = optional(number, 0)
    }), null)
  }))
  default = []
}

variable "databases" {
  description = <<EOF
    (Required) A list of ClickHouse databases.

    Required values:
      - name - The name of the database.
  EOF

  type = list(object({
    name = string
  }))
  default = []
}

variable "hosts" {
  description = <<EOF
    (Required) A list of ClickHouse hosts.
    - type - (Required) The type of the host to be deployed. Can be either "CLICKHOUSE" or "ZOOKEEPER".
    - zone  - (Required) The availability zone where the ClickHouse host will be created. Allowed values: "ru-central1-a", "ru-central1-b", "ru-central1-c".
    - subnet_id - (Optional) The ID of the subnet, to which the host belongs. The subnet must be a part of the network to which the cluster belongs.
    - shard_name - (Optional) The name of the shard to which the host belongs.
    - assign_public_ip - (Optional) Sets whether the host should get a public IP address on creation. Can be either true or false.
  EOF

  type = list(object({
    type             = string
    zone             = string
    subnet_id        = optional(string, null)
    shard_name       = optional(string, null)
    assign_public_ip = optional(bool, null)
  }))
  default = []
  validation {
    condition     = length(var.hosts) > 0
    error_message = "At least one host must be defined."
  }
}

# Optionals
variable "name" {
  description = <<EOF
    (Optional) Name of ClickHouse cluster.

    Default: "clickhouse-cluster"
  EOF
  type        = string
  default     = "clickhouse-cluster"
}

variable "clickhouse_disk_size" {
  description = <<EOF
    (Optional) Disk size for hosts.

    Default: 10
  EOF

  type    = number
  default = 10
}

variable "clickhouse_disk_type_id" {
  description = <<EOF
    (Optional) Disk type for hosts.

    Allowed types:
      - network-hdd
      - network-ssd
      - network-ssd-nonreplicated
      - local-ssd

    "local-ssd" restrictions:
      - For Intel Broadwell and Intel Cascade Lake: Only in increments of 100 GB.
      - For Intel Ice Lake: Only in increments of 368 GB.

    Default: "network-ssd"
  EOF

  type    = string
  default = "network-ssd"
  validation {
    condition = contains([
      "network-hdd", "network-ssd", "network-ssd-nonreplicated", "local-ssd"
    ], var.clickhouse_disk_type_id)
    error_message = "Allowed ClickHouse disk type are \"network-hdd\", \"network-ssd\", \"network-ssd-nonreplicated\", \"local-ssd\"."
  }
}

variable "clickhouse_resource_preset_id" {
  description = <<EOF
    (Optional) Preset for hosts.
    All types: https://cloud.yandex.com/en/docs/managed-clickhouse/concepts/instance-types

    Default: "s3-c2-m8"
  EOF

  type    = string
  default = "s3-c2-m8"
}

variable "environment" {
  description = <<EOF
    (Optional) Environment type: "PRODUCTION" or "PRESTABLE".

    Default: "PRODUCTION"
  EOF

  type    = string
  default = "PRODUCTION"
  validation {
    condition     = contains(["PRODUCTION", "PRESTABLE"], var.environment)
    error_message = "Release channel should be PRODUCTION (stable feature set) or PRESTABLE (early bird feature access)."
  }
}

variable "clickhouse_version" {
  description = <<EOF
    (Optional) ClickHouse version.

    Default: "24.8"
  EOF

  type    = string
  default = "24.8"
}

variable "description" {
  description = <<EOF
    (Optional) ClickHouse cluster description.

    Default: null
  EOF

  type    = string
  default = null
}

variable "folder_id" {
  description = <<EOF
    (Optional) Folder id that contains the ClickHouse cluster.

    Default: null
  EOF

  type    = string
  default = null
}

variable "labels" {
  description = <<EOF
    (Optional) A set of label pairs to assign to the ClickHouse cluster.

    Default: {}
  EOF

  type    = map(any)
  default = {}
}

variable "backup_window_start" {
  description = <<EOF
    (Optional) Time to start the daily backup, in the UTC timezone.

    Default: null
  EOF

  type = object({
    hours   = string
    minutes = optional(string, "00")
  })
  default = null
}

variable "access" {
  description = <<EOF
    (Optional) Access policy from other services to the ClickHouse cluster.

    Default: null
  EOF

  type = object({
    data_lens     = optional(bool, null)
    metrika       = optional(bool, null)
    web_sql       = optional(bool, null)
    serverless    = optional(bool, null)
    yandex_query  = optional(bool, null)
    data_transfer = optional(bool, null)
  })
  default = {}
}

variable "zookeeper_disk_size" {
  description = <<EOF
    (Optional) Volume of the storage available to a ZooKeeper host, in gigabytes.

    Default: 0
  EOF

  type    = number
  default = 0
}

variable "zookeeper_disk_type_id" {
  description = <<EOF
    (Optional) Type of the storage of ZooKeeper hosts.

    Allowed types:
      - network-hdd
      - network-ssd
      - network-ssd-nonreplicated
      - local-ssd

    "local-ssd" restrictions:
      - For Intel Broadwell and Intel Cascade Lake: Only in increments of 100 GB.
      - For Intel Ice Lake: Only in increments of 368 GB.

    For more information see the official documentation.
    Link: https://cloud.yandex.com/en-ru/docs/managed-clickhouse/concepts/storage

    Default: ""
  EOF

  type    = string
  default = ""
  validation {
    condition = contains([
      "network-hdd", "network-ssd", "network-ssd-nonreplicated", "local-ssd", ""
    ], var.zookeeper_disk_type_id)
    error_message = "Allowed ClickHouse disk type are \"network-hdd\", \"network-ssd\", \"network-ssd-nonreplicated\", \"local-ssd\"."
  }
}

variable "zookeeper_resource_preset_id" {
  description = <<EOF
    (Optional) The ID of the preset for computational resources available to a ZooKeeper host (CPU, memory etc.). For more information, see the official documentation.
    Link: https://cloud.yandex.com/en/docs/managed-clickhouse/concepts/instance-types

    Default: ""
  EOF

  type    = string
  default = ""
}

variable "shard_group" {
  description = <<EOF
    (Optional) A group of clickhouse shards.
    - name - (Required) - The name of the shard group, used as cluster name in Distributed tables.
    - shard_names - (Required) - List of shards names that belong to the shard group.
    - description - (Optional) - Description of the shard group.

    Default: null
  EOF

  type = object({
    name        = string
    shard_names = list(string)
    description = optional(string, "")
  })
  default = null
}

variable "shards" {
  description = <<EOF
    - name      - (Required) The name of shard.
    - weight    - (Optional) The weight of shard.
    - resources - (Optional) Resources allocated to host of the shard. The resources specified for the shard takes precedence over the resources specified for the cluster. .
      - resource_preset_id - Preset for hosts.
      - disk_size          - Disk size for hosts
      - disk_type_id       - Disk type for hosts. One of: "network-hdd", "network-ssd", "network-ssd-nonreplicated", "local-ssd".

    Default: []
  EOF

  type = list(object({
    name   = string
    weight = optional(number, null)
    resources = optional(object({
      resource_preset_id = string
      disk_size          = number
      disk_type_id       = string
    }), null)
  }))
  default = []
}

variable "format_schema" {
  description = <<EOF
    (Optional) A set of protobuf or capnproto format schemas.
    - name - (Required) The name of the ml model.
    - type - (Required) Type of the model.
    - uri  - (Required) Model file URL. You can only use models stored in Yandex Object Storage.

    Default: null
  EOF

  type = object({
    name = string
    type = string
    uri  = string
  })
  default = null
}

variable "ml_model" {
  description = <<EOF
    (Optional) A group of machine learning models.
    - name - (Required) The name of the ml model.
    - type - (Required) Type of the model.
    - uri - (Required) Model file URL. You can only use models stored in Yandex Object Storage.

    Default: null
  EOF

  type = object({
    name = string
    type = string
    uri  = string
  })
  default = null
}

variable "cloud_storage" {
  description = <<EOF
    - enabled             - (Required) Whether to use Yandex Object Storage for storing ClickHouse data. Can be either true or false.
    - move_factor         - (Optional) Sets the minimum free space ratio in the cluster storage. If the free space is lower than this value, the data is transferred to Yandex Object Storage. Acceptable values are 0 to 1, inclusive.
    - data_cache_enabled  - (Optional) Enables temporary storage in the cluster repository of data requested from the object repository.
    - data_cache_max_size - (Optional) Defines the maximum amount of memory (in bytes) allocated in the cluster storage for temporary storage of data requested from the object storage.

    Default: null
  EOF

  type = object({
    enabled             = optional(bool, false)
    move_factor         = optional(number, 0)
    data_cache_enabled  = optional(bool, false)
    data_cache_max_size = optional(number, 0)
  })
  default = null
}

variable "admin_password" {
  description = <<EOF
    (Optional) A password used to authorize as user admin when sql_user_management enabled.

    Default: null
  EOF

  type    = string
  default = null
}

variable "sql_user_management" {
  description = <<EOF
    (Optional, ForceNew) Enables admin user with user management permission.

    Default: false
  EOF

  type    = bool
  default = false
}

variable "sql_database_management" {
  description = <<EOF
    (Optional, ForceNew) Grants admin user database management permission.

    Default: false
  EOF

  type    = bool
  default = false
}

variable "embedded_keeper" {
  description = <<EOF
    (Optional, ForceNew) Whether to use ClickHouse Keeper as a coordination system and place it on the same hosts with ClickHouse. If not, it's used ZooKeeper with placement on separate hosts.

    Default: false
  EOF

  type    = bool
  default = false
}

variable "security_group_ids" {
  description = <<EOF
    (Optional) A list of security group IDs to which the ClickHouse cluster belongs.

    Default: []
  EOF

  type     = list(string)
  default  = []
  nullable = true
}

variable "copy_schema_on_new_hosts" {
  description = <<EOF
    (Optional) Whether to copy schema on new ClickHouse hosts.

    Default: false
  EOF

  type    = bool
  default = false
}

variable "deletion_protection" {
  description = <<EOF
    (Optional) Inhibits deletion of the cluster.

    Default: false
  EOF

  type    = bool
  default = false
}

variable "maintenance_window" {
  description = <<EOF
    (Optional) Maintenance policy of the ClickHouse cluster.
    - type - (Required) Type of maintenance window. Can be either ANYTIME or WEEKLY. A day and hour of window need to be specified with weekly window.
    - day  - (Optional) Day of the week (in DDD format). Allowed values: "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"
    - hour - (Optional) Hour of the day in UTC (in HH format). Allowed value is between 0 and 23.

    Default: {type = "ANYTIME"}
  EOF

  type = object({
    type = string
    day  = optional(string, null)
    hour = optional(string, null)
  })
  default = {
    type = "ANYTIME"
  }
}

variable "clickhouse_config" {
  description = <<EOF
    (Optional) Main ClickHouse cluster configuration. For more information, see the official documentation.
    Link 1: https://cloud.yandex.com/en-ru/docs/managed-clickhouse/concepts/settings-list
    Link 2: https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_clickhouse_cluster#config
  EOF

  type = object({
    background_fetches_pool_size    = optional(number, 0)
    background_pool_size            = optional(number, 0)
    background_schedule_pool_size   = optional(number, 0)
    default_database                = optional(string, "")
    geobase_uri                     = optional(string, "")
    keep_alive_timeout              = optional(number, 3)
    log_level                       = optional(string, "DEBUG")
    mark_cache_size                 = optional(number, 5368709120)
    max_concurrent_queries          = optional(number, 500)
    max_connections                 = optional(number, 4096)
    max_partition_size_to_drop      = optional(number, 53687091200)
    max_table_size_to_drop          = optional(number, 53687091200)
    metric_log_enabled              = optional(bool, true)
    metric_log_retention_size       = optional(number, 536870912)
    metric_log_retention_time       = optional(number, 2592000000)
    part_log_retention_size         = optional(number, 536870912)
    part_log_retention_time         = optional(number, 2592000000)
    query_log_retention_size        = optional(number, 1073741824)
    query_log_retention_time        = optional(number, 2592000000)
    query_thread_log_enabled        = optional(bool, true)
    query_thread_log_retention_size = optional(number, 536870912)
    query_thread_log_retention_time = optional(number, 2592000000)
    text_log_enabled                = optional(bool, false)
    text_log_level                  = optional(string, "TRACE")
    text_log_retention_size         = optional(number, 536870912)
    text_log_retention_time         = optional(number, 2592000000)
    timezone                        = optional(string, "Europe/Moscow")
    total_memory_profiler_step      = optional(number, 0)
    trace_log_enabled               = optional(bool, true)
    trace_log_retention_size        = optional(number, 536870912)
    trace_log_retention_time        = optional(number, 2592000000)
    uncompressed_cache_size         = optional(number, 8589934592)
    compression = optional(object({
      method              = optional(string, null)
      min_part_size       = optional(number, null)
      min_part_size_ratio = optional(number, null)
    }), null)
    graphite_rollup = optional(object({
      name = string
      pattern = object({
        function = string
        regexp   = optional(string, null)
        retention = object({
          age       = number
          precision = number
        })
      })
    }), null)
    kafka = optional(object({
      security_protocol = optional(string, null)
      sasl_mechanism    = optional(string, null)
      sasl_username     = optional(string, null)
      sasl_password     = optional(string, null)
    }), null)
    kafka_topic = optional(object({
      name = string
      settings = optional(object({
        security_protocol = optional(string, null)
        sasl_mechanism    = optional(string, null)
        sasl_username     = optional(string, null)
        sasl_password     = optional(string, null)
      }), null)
    }), null)
    merge_tree = optional(object({
      max_bytes_to_merge_at_min_space_in_pool                   = optional(number, 53687091200)
      max_replicated_merges_in_queue                            = optional(number, 16)
      min_bytes_for_wide_part                                   = optional(number, 0)
      min_rows_for_wide_part                                    = optional(number, 0)
      number_of_free_entries_in_pool_to_lower_max_size_of_merge = optional(number, 8)
      parts_to_delay_insert                                     = optional(number, 150)
      parts_to_throw_insert                                     = optional(number, 300)
      replicated_deduplication_window                           = optional(number, 100)
      replicated_deduplication_window_seconds                   = optional(number, 604800)
      ttl_only_drop_parts                                       = optional(bool, false)
    }), null)
    rabbitmq = optional(object({
      username = optional(string, "")
      password = optional(string, "")
      vhost    = optional(string, "")
    }), null)
  })

  default = null
}

variable "timeouts" {
  description = "Timeout settings for cluster operations"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

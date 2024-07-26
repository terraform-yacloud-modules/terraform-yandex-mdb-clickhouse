variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "zone" {
  description = "Yandex Cloud zone"
  default     = "ru-central1-a"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet, to which the host belongs. The subnet must be a part of the network to which the cluster belongs"
  type        = string
}

variable "network_id" {
  description = "ID of the network, to which the Redis cluster belongs"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ClickHouse cluster"
  type        = string
}

variable "environment" {
  description = "Deployment environment of the ClickHouse cluster"
  type        = string
  default     = "PRODUCTION"  # "PRODUCTION" or "PRESTABLE"
}

variable "resource_preset_id" {
  description = "The ID of the preset for computational resources available to a ClickHouse host"
  type        = string
  default     = "s3-c2-m8" # https://yandex.cloud/en/docs/managed-clickhouse/concepts/instance-types
}

variable "disk_type_id" {
  description = "Type of the storage of ClickHouse hosts"
  type        = string
  default     = "network-ssd"
}

variable "disk_size" {
  description = "Volume of the storage available to a ClickHouse host, in gigabytes"
  type        = number
  default     = 33
}

variable "log_level" {
  description = "Log level"
  type        = string
  default     = "TRACE"
}

variable "max_connections" {
  description = "Maximum number of connections"
  type        = number
  default     = 100
}

variable "max_concurrent_queries" {
  description = "Maximum number of concurrent queries"
  type        = number
  default     = 50
}

variable "keep_alive_timeout" {
  description = "Keep alive timeout in milliseconds"
  type        = number
  default     = 3000
}

variable "uncompressed_cache_size" {
  description = "Uncompressed cache size"
  type        = number
  default     = 8589934592
}

variable "mark_cache_size" {
  description = "Mark cache size"
  type        = number
  default     = 5368709120
}

variable "max_table_size_to_drop" {
  description = "Maximum table size to drop"
  type        = number
  default     = 53687091200
}

variable "max_partition_size_to_drop" {
  description = "Maximum partition size to drop"
  type        = number
  default     = 53687091200
}

variable "timezone" {
  description = "Timezone"
  type        = string
  default     = "UTC"
}

variable "geobase_uri" {
  description = "Geobase URI"
  type        = string
  default     = ""
}

variable "query_log_retention_size" {
  description = "Query log retention size"
  type        = number
  default     = 1073741824
}

variable "query_log_retention_time" {
  description = "Query log retention time"
  type        = number
  default     = 86400000 # 1 day in milliseconds
}

variable "query_thread_log_enabled" {
  description = "Query thread log enabled"
  type        = bool
  default     = true
}

variable "query_thread_log_retention_size" {
  description = "Query thread log retention size"
  type        = number
  default     = 536870912
}

variable "query_thread_log_retention_time" {
  description = "Query thread log retention time"
  type        = number
  default     = 86400000 # 1 day in milliseconds
}

variable "part_log_retention_size" {
  description = "Part log retention size"
  type        = number
  default     = 536870912
}

variable "part_log_retention_time" {
  description = "Part log retention time"
  type        = number
  default     = 86400000 # 1 day in milliseconds
}

variable "metric_log_enabled" {
  description = "Metric log enabled"
  type        = bool
  default     = true
}

variable "metric_log_retention_size" {
  description = "Metric log retention size"
  type        = number
  default     = 536870912
}

variable "metric_log_retention_time" {
  description = "Metric log retention time"
  type        = number
  default     = 86400000 # 1 day in milliseconds
}

variable "trace_log_enabled" {
  description = "Trace log enabled"
  type        = bool
  default     = true
}

variable "trace_log_retention_size" {
  description = "Trace log retention size"
  type        = number
  default     = 536870912
}

variable "trace_log_retention_time" {
  description = "Trace log retention time"
  type        = number
  default     = 86400000 # 1 day in milliseconds
}

variable "text_log_enabled" {
  description = "Text log enabled"
  type        = bool
  default     = true
}

variable "text_log_retention_size" {
  description = "Text log retention size"
  type        = number
  default     = 536870912
}

variable "text_log_retention_time" {
  description = "Text log retention time"
  type        = number
  default     = 86400000 # 1 day in milliseconds
}

variable "text_log_level" {
  description = "Text log level"
  type        = string
  default     = "TRACE"
}

variable "background_pool_size" {
  description = "Background pool size"
  type        = number
  default     = 16
}

variable "background_schedule_pool_size" {
  description = "Background schedule pool size"
  type        = number
  default     = 16
}

variable "replicated_deduplication_window" {
  description = "Replicated deduplication window"
  type        = number
  default     = 100
}

variable "replicated_deduplication_window_seconds" {
  description = "Replicated deduplication window seconds"
  type        = number
  default     = 604800
}

variable "parts_to_delay_insert" {
  description = "Parts to delay insert"
  type        = number
  default     = 150
}

variable "parts_to_throw_insert" {
  description = "Parts to throw insert"
  type        = number
  default     = 300
}

variable "max_replicated_merges_in_queue" {
  description = "Max replicated merges in queue"
  type        = number
  default     = 16
}

variable "number_of_free_entries_in_pool_to_lower_max_size_of_merge" {
  description = "Number of free entries in pool to lower max size of merge"
  type        = number
  default     = 8
}

variable "max_bytes_to_merge_at_min_space_in_pool" {
  description = "Max bytes to merge at min space in pool"
  type        = number
  default     = 1048576
}

variable "kafka_security_protocol" {
  description = "Kafka security protocol"
  type        = string
  default     = "SECURITY_PROTOCOL_PLAINTEXT"
}

variable "kafka_sasl_mechanism" {
  description = "Kafka SASL mechanism"
  type        = string
  default     = "SASL_MECHANISM_GSSAPI"
}

variable "kafka_sasl_username" {
  description = "Kafka SASL username"
  type        = string
  default     = "user1"
}

variable "kafka_sasl_password" {
  description = "Kafka SASL password"
  type        = string
  sensitive   = true
  default     = "pass1"
}

variable "kafka_topic_name" {
  description = "Kafka topic name"
  type        = string
  default     = "topic1"
}

variable "kafka_topic_security_protocol" {
  description = "Kafka topic security protocol"
  type        = string
  default     = "SECURITY_PROTOCOL_SSL"
}

variable "kafka_topic_sasl_mechanism" {
  description = "Kafka topic SASL mechanism"
  type        = string
  default     = "SASL_MECHANISM_SCRAM_SHA_256"
}

variable "kafka_topic_sasl_username" {
  description = "Kafka topic SASL username"
  type        = string
  default     = "user2"
}

variable "kafka_topic_sasl_password" {
  description = "Kafka topic SASL password"
  type        = string
  sensitive   = true
  default     = "pass2"
}

variable "rabbitmq_username" {
  description = "RabbitMQ username"
  type        = string
  default     = "rabbit_user"
}

variable "rabbitmq_password" {
  description = "RabbitMQ password"
  type        = string
  sensitive   = true
  default     = "rabbit_pass"
}

variable "compression_method" {
  description = "Compression method"
  type        = string
  default     = "LZ4"
}

variable "compression_min_part_size" {
  description = "Compression min part size"
  type        = number
  default     = 1024
}

variable "compression_min_part_size_ratio" {
  description = "Compression min part size ratio"
  type        = number
  default     = 0.5
}

variable "graphite_rollup_name" {
  description = "Graphite rollup name"
  type        = string
  default     = "rollup1"
}

variable "graphite_rollup_regexp" {
  description = "Graphite rollup regexp"
  type        = string
  default     = "abc"
}

variable "graphite_rollup_function" {
  description = "Graphite rollup function"
  type        = string
  default     = "func1"
}

variable "graphite_rollup_retention_age" {
  description = "Graphite rollup retention age"
  type        = number
  default     = 1000
}

variable "graphite_rollup_retention_precision" {
  description = "Graphite rollup retention precision"
  type        = number
  default     = 3
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "db_name"
}

variable "user_name" {
  description = "User name"
  type        = string
  default     = "user"
}

variable "user_password" {
  description = "User password"
  type        = string
  sensitive   = true
}

variable "max_memory_usage_for_user" {
  description = "Max memory usage for user"
  type        = number
  default     = 1000000000
}

variable "read_overflow_mode" {
  description = "Read overflow mode"
  type        = string
  default     = "throw"
}

variable "output_format_json_quote_64bit_integers" {
  description = "Output format JSON quote 64bit integers"
  type        = bool
  default     = true
}

variable "quota_interval_duration" {
  description = "Quota interval duration"
  type        = number
  default     = 3600000
}

variable "quota_queries" {
  description = "Quota queries"
  type        = number
  default     = 10000
}

variable "quota_errors" {
  description = "Quota errors"
  type        = number
  default     = 1000
}

variable "service_account_id" {
  description = "Service account ID"
  type        = string
}

variable "cloud_storage_enabled" {
  description = "Cloud storage enabled"
  type        = bool
  default     = false
}

variable "maintenance_window_type" {
  description = "Maintenance window type"
  type        = string
  default     = "ANYTIME"
}

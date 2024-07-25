# variable "yc_token" {
#   description = "Yandex Cloud API token"
#   sensitive   = true
# }
#
# variable "yc_cloud_id" {
#   description = "Yandex Cloud ID"
# }

variable "yc_folder_id" {
  description = "Yandex Cloud folder ID"
}

variable "yc_zone" {
  description = "Yandex Cloud zone"
  default     = "ru-central1-a"
}

variable "cluster_name" {
  description = "Name of the ClickHouse cluster"
}

variable "environment" {
  description = "Deployment environment of the ClickHouse cluster"
  default     = "PRODUCTION"
}

variable "resource_preset_id" {
  description = "The ID of the preset for computational resources available to a ClickHouse host"
  default     = "s2.micro"
}

variable "disk_type_id" {
  description = "Type of the storage of ClickHouse hosts"
  default     = "network-ssd"
}

variable "disk_size" {
  description = "Volume of the storage available to a ClickHouse host, in gigabytes"
  default     = 32
}

variable "log_level" {
  description = "Log level"
  default     = "TRACE"
}

variable "max_connections" {
  description = "Maximum number of connections"
  default     = 100
}

variable "max_concurrent_queries" {
  description = "Maximum number of concurrent queries"
  default     = 50
}

variable "keep_alive_timeout" {
  description = "Keep alive timeout in milliseconds"
  default     = 3000
}

variable "uncompressed_cache_size" {
  description = "Uncompressed cache size"
  default     = 8589934592
}

variable "mark_cache_size" {
  description = "Mark cache size"
  default     = 5368709120
}

variable "max_table_size_to_drop" {
  description = "Maximum table size to drop"
  default     = 53687091200
}

variable "max_partition_size_to_drop" {
  description = "Maximum partition size to drop"
  default     = 53687091200
}

variable "timezone" {
  description = "Timezone"
  default     = "UTC"
}

variable "geobase_uri" {
  description = "Geobase URI"
  default     = ""
}

variable "query_log_retention_size" {
  description = "Query log retention size"
  default     = 1073741824
}

variable "query_log_retention_time" {
  description = "Query log retention time"
  default     = 2592000
}

variable "query_thread_log_enabled" {
  description = "Query thread log enabled"
  default     = true
}

variable "query_thread_log_retention_size" {
  description = "Query thread log retention size"
  default     = 536870912
}

variable "query_thread_log_retention_time" {
  description = "Query thread log retention time"
  default     = 2592000
}

variable "part_log_retention_size" {
  description = "Part log retention size"
  default     = 536870912
}

variable "part_log_retention_time" {
  description = "Part log retention time"
  default     = 2592000
}

variable "metric_log_enabled" {
  description = "Metric log enabled"
  default     = true
}

variable "metric_log_retention_size" {
  description = "Metric log retention size"
  default     = 536870912
}

variable "metric_log_retention_time" {
  description = "Metric log retention time"
  default     = 2592000
}

variable "trace_log_enabled" {
  description = "Trace log enabled"
  default     = true
}

variable "trace_log_retention_size" {
  description = "Trace log retention size"
  default     = 536870912
}

variable "trace_log_retention_time" {
  description = "Trace log retention time"
  default     = 2592000
}

variable "text_log_enabled" {
  description = "Text log enabled"
  default     = true
}

variable "text_log_retention_size" {
  description = "Text log retention size"
  default     = 536870912
}

variable "text_log_retention_time" {
  description = "Text log retention time"
  default     = 2592000
}

variable "text_log_level" {
  description = "Text log level"
  default     = "TRACE"
}

variable "background_pool_size" {
  description = "Background pool size"
  default     = 16
}

variable "background_schedule_pool_size" {
  description = "Background schedule pool size"
  default     = 16
}

variable "replicated_deduplication_window" {
  description = "Replicated deduplication window"
  default     = 100
}

variable "replicated_deduplication_window_seconds" {
  description = "Replicated deduplication window seconds"
  default     = 604800
}

variable "parts_to_delay_insert" {
  description = "Parts to delay insert"
  default     = 150
}

variable "parts_to_throw_insert" {
  description = "Parts to throw insert"
  default     = 300
}

variable "max_replicated_merges_in_queue" {
  description = "Max replicated merges in queue"
  default     = 16
}

variable "number_of_free_entries_in_pool_to_lower_max_size_of_merge" {
  description = "Number of free entries in pool to lower max size of merge"
  default     = 8
}

variable "max_bytes_to_merge_at_min_space_in_pool" {
  description = "Max bytes to merge at min space in pool"
  default     = 1048576
}

variable "kafka_security_protocol" {
  description = "Kafka security protocol"
  default     = "SECURITY_PROTOCOL_PLAINTEXT"
}

variable "kafka_sasl_mechanism" {
  description = "Kafka SASL mechanism"
  default     = "SASL_MECHANISM_GSSAPI"
}

variable "kafka_sasl_username" {
  description = "Kafka SASL username"
  default     = "user1"
}

variable "kafka_sasl_password" {
  description = "Kafka SASL password"
  sensitive   = true
  default     = "pass1"
}

variable "kafka_topic_name" {
  description = "Kafka topic name"
  default     = "topic1"
}

variable "kafka_topic_security_protocol" {
  description = "Kafka topic security protocol"
  default     = "SECURITY_PROTOCOL_SSL"
}

variable "kafka_topic_sasl_mechanism" {
  description = "Kafka topic SASL mechanism"
  default     = "SASL_MECHANISM_SCRAM_SHA_256"
}

variable "kafka_topic_sasl_username" {
  description = "Kafka topic SASL username"
  default     = "user2"
}

variable "kafka_topic_sasl_password" {
  description = "Kafka topic SASL password"
  sensitive   = true
  default     = "pass2"
}

variable "rabbitmq_username" {
  description = "RabbitMQ username"
  default     = "rabbit_user"
}

variable "rabbitmq_password" {
  description = "RabbitMQ password"
  sensitive   = true
  default     = "rabbit_pass"
}

variable "compression_method" {
  description = "Compression method"
  default     = "LZ4"
}

variable "compression_min_part_size" {
  description = "Compression min part size"
  default     = 1024
}

variable "compression_min_part_size_ratio" {
  description = "Compression min part size ratio"
  default     = 0.5
}

variable "graphite_rollup_name" {
  description = "Graphite rollup name"
  default     = "rollup1"
}

variable "graphite_rollup_regexp" {
  description = "Graphite rollup regexp"
  default     = "abc"
}

variable "graphite_rollup_function" {
  description = "Graphite rollup function"
  default     = "func1"
}

variable "graphite_rollup_retention_age" {
  description = "Graphite rollup retention age"
  default     = 1000
}

variable "graphite_rollup_retention_precision" {
  description = "Graphite rollup retention precision"
  default     = 3
}

variable "database_name" {
  description = "Database name"
  default     = "db_name"
}

variable "user_name" {
  description = "User name"
  default     = "user"
}

variable "user_password" {
  description = "User password"
  sensitive   = true
  default     = "your_password"
}

variable "max_memory_usage_for_user" {
  description = "Max memory usage for user"
  default     = 1000000000
}

variable "read_overflow_mode" {
  description = "Read overflow mode"
  default     = "throw"
}

variable "output_format_json_quote_64bit_integers" {
  description = "Output format JSON quote 64bit integers"
  default     = true
}

variable "quota_interval_duration" {
  description = "Quota interval duration"
  default     = 3600000
}

variable "quota_queries" {
  description = "Quota queries"
  default     = 10000
}

variable "quota_errors" {
  description = "Quota errors"
  default     = 1000
}

variable "format_schema_name" {
  description = "Format schema name"
  default     = "test_schema"
}

variable "format_schema_type" {
  description = "Format schema type"
  default     = "FORMAT_SCHEMA_TYPE_CAPNPROTO"
}

variable "format_schema_uri" {
  description = "Format schema URI"
  default     = "https://storage.yandexcloud.net/ch-data/schema.proto"
}

variable "ml_model_name" {
  description = "ML model name"
  default     = "test_model"
}

variable "ml_model_type" {
  description = "ML model type"
  default     = "ML_MODEL_TYPE_CATBOOST"
}

variable "ml_model_uri" {
  description = "ML model URI"
  default     = "https://storage.yandexcloud.net/ch-data/train.csv"
}

variable "service_account_id" {
  description = "Service account ID"
  default     = "your_service_account_id"
}

variable "cloud_storage_enabled" {
  description = "Cloud storage enabled"
  default     = false
}

variable "maintenance_window_type" {
  description = "Maintenance window type"
  default     = "ANYTIME"
}

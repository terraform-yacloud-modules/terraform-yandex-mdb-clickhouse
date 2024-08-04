# Yandex Cloud ClickHouse Terraform module

Terraform module which creates Yandex Cloud ClickHouse resources.

Fork of https://github.com/polina-yudina/terraform-yc-clickhouse

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.72.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.72.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_mdb_clickhouse_cluster.clickhouse_cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_clickhouse_cluster) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_background_pool_size"></a> [background\_pool\_size](#input\_background\_pool\_size) | Background pool size | `number` | `16` | no |
| <a name="input_background_schedule_pool_size"></a> [background\_schedule\_pool\_size](#input\_background\_schedule\_pool\_size) | Background schedule pool size | `number` | `16` | no |
| <a name="input_cloud_storage_enabled"></a> [cloud\_storage\_enabled](#input\_cloud\_storage\_enabled) | Cloud storage enabled | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ClickHouse cluster | `string` | n/a | yes |
| <a name="input_compression_method"></a> [compression\_method](#input\_compression\_method) | Compression method | `string` | `"LZ4"` | no |
| <a name="input_compression_min_part_size"></a> [compression\_min\_part\_size](#input\_compression\_min\_part\_size) | Compression min part size | `number` | `1024` | no |
| <a name="input_compression_min_part_size_ratio"></a> [compression\_min\_part\_size\_ratio](#input\_compression\_min\_part\_size\_ratio) | Compression min part size ratio | `number` | `0.5` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Database name | `string` | `"db_name"` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Volume of the storage available to a ClickHouse host, in gigabytes | `number` | `33` | no |
| <a name="input_disk_type_id"></a> [disk\_type\_id](#input\_disk\_type\_id) | Type of the storage of ClickHouse hosts | `string` | `"network-ssd"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment of the ClickHouse cluster | `string` | `"PRODUCTION"` | no |
| <a name="input_geobase_uri"></a> [geobase\_uri](#input\_geobase\_uri) | Geobase URI | `string` | `""` | no |
| <a name="input_graphite_rollup_function"></a> [graphite\_rollup\_function](#input\_graphite\_rollup\_function) | Graphite rollup function | `string` | `"func1"` | no |
| <a name="input_graphite_rollup_name"></a> [graphite\_rollup\_name](#input\_graphite\_rollup\_name) | Graphite rollup name | `string` | `"rollup1"` | no |
| <a name="input_graphite_rollup_regexp"></a> [graphite\_rollup\_regexp](#input\_graphite\_rollup\_regexp) | Graphite rollup regexp | `string` | `"abc"` | no |
| <a name="input_graphite_rollup_retention_age"></a> [graphite\_rollup\_retention\_age](#input\_graphite\_rollup\_retention\_age) | Graphite rollup retention age | `number` | `1000` | no |
| <a name="input_graphite_rollup_retention_precision"></a> [graphite\_rollup\_retention\_precision](#input\_graphite\_rollup\_retention\_precision) | Graphite rollup retention precision | `number` | `3` | no |
| <a name="input_kafka_sasl_mechanism"></a> [kafka\_sasl\_mechanism](#input\_kafka\_sasl\_mechanism) | Kafka SASL mechanism | `string` | `"SASL_MECHANISM_GSSAPI"` | no |
| <a name="input_kafka_sasl_password"></a> [kafka\_sasl\_password](#input\_kafka\_sasl\_password) | Kafka SASL password | `string` | `"pass1"` | no |
| <a name="input_kafka_sasl_username"></a> [kafka\_sasl\_username](#input\_kafka\_sasl\_username) | Kafka SASL username | `string` | `"user1"` | no |
| <a name="input_kafka_security_protocol"></a> [kafka\_security\_protocol](#input\_kafka\_security\_protocol) | Kafka security protocol | `string` | `"SECURITY_PROTOCOL_PLAINTEXT"` | no |
| <a name="input_kafka_topic_name"></a> [kafka\_topic\_name](#input\_kafka\_topic\_name) | Kafka topic name | `string` | `"topic1"` | no |
| <a name="input_kafka_topic_sasl_mechanism"></a> [kafka\_topic\_sasl\_mechanism](#input\_kafka\_topic\_sasl\_mechanism) | Kafka topic SASL mechanism | `string` | `"SASL_MECHANISM_SCRAM_SHA_256"` | no |
| <a name="input_kafka_topic_sasl_password"></a> [kafka\_topic\_sasl\_password](#input\_kafka\_topic\_sasl\_password) | Kafka topic SASL password | `string` | `"pass2"` | no |
| <a name="input_kafka_topic_sasl_username"></a> [kafka\_topic\_sasl\_username](#input\_kafka\_topic\_sasl\_username) | Kafka topic SASL username | `string` | `"user2"` | no |
| <a name="input_kafka_topic_security_protocol"></a> [kafka\_topic\_security\_protocol](#input\_kafka\_topic\_security\_protocol) | Kafka topic security protocol | `string` | `"SECURITY_PROTOCOL_SSL"` | no |
| <a name="input_keep_alive_timeout"></a> [keep\_alive\_timeout](#input\_keep\_alive\_timeout) | Keep alive timeout in milliseconds | `number` | `3000` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Log level | `string` | `"TRACE"` | no |
| <a name="input_maintenance_window_type"></a> [maintenance\_window\_type](#input\_maintenance\_window\_type) | Maintenance window type | `string` | `"ANYTIME"` | no |
| <a name="input_mark_cache_size"></a> [mark\_cache\_size](#input\_mark\_cache\_size) | Mark cache size | `number` | `5368709120` | no |
| <a name="input_max_bytes_to_merge_at_min_space_in_pool"></a> [max\_bytes\_to\_merge\_at\_min\_space\_in\_pool](#input\_max\_bytes\_to\_merge\_at\_min\_space\_in\_pool) | Max bytes to merge at min space in pool | `number` | `1048576` | no |
| <a name="input_max_concurrent_queries"></a> [max\_concurrent\_queries](#input\_max\_concurrent\_queries) | Maximum number of concurrent queries | `number` | `50` | no |
| <a name="input_max_connections"></a> [max\_connections](#input\_max\_connections) | Maximum number of connections | `number` | `100` | no |
| <a name="input_max_memory_usage_for_user"></a> [max\_memory\_usage\_for\_user](#input\_max\_memory\_usage\_for\_user) | Max memory usage for user | `number` | `1000000000` | no |
| <a name="input_max_partition_size_to_drop"></a> [max\_partition\_size\_to\_drop](#input\_max\_partition\_size\_to\_drop) | Maximum partition size to drop | `number` | `53687091200` | no |
| <a name="input_max_replicated_merges_in_queue"></a> [max\_replicated\_merges\_in\_queue](#input\_max\_replicated\_merges\_in\_queue) | Max replicated merges in queue | `number` | `16` | no |
| <a name="input_max_table_size_to_drop"></a> [max\_table\_size\_to\_drop](#input\_max\_table\_size\_to\_drop) | Maximum table size to drop | `number` | `53687091200` | no |
| <a name="input_metric_log_enabled"></a> [metric\_log\_enabled](#input\_metric\_log\_enabled) | Metric log enabled | `bool` | `true` | no |
| <a name="input_metric_log_retention_size"></a> [metric\_log\_retention\_size](#input\_metric\_log\_retention\_size) | Metric log retention size | `number` | `536870912` | no |
| <a name="input_metric_log_retention_time"></a> [metric\_log\_retention\_time](#input\_metric\_log\_retention\_time) | Metric log retention time | `number` | `86400000` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | ID of the network, to which the Redis cluster belongs | `string` | n/a | yes |
| <a name="input_number_of_free_entries_in_pool_to_lower_max_size_of_merge"></a> [number\_of\_free\_entries\_in\_pool\_to\_lower\_max\_size\_of\_merge](#input\_number\_of\_free\_entries\_in\_pool\_to\_lower\_max\_size\_of\_merge) | Number of free entries in pool to lower max size of merge | `number` | `8` | no |
| <a name="input_output_format_json_quote_64bit_integers"></a> [output\_format\_json\_quote\_64bit\_integers](#input\_output\_format\_json\_quote\_64bit\_integers) | Output format JSON quote 64bit integers | `bool` | `true` | no |
| <a name="input_part_log_retention_size"></a> [part\_log\_retention\_size](#input\_part\_log\_retention\_size) | Part log retention size | `number` | `536870912` | no |
| <a name="input_part_log_retention_time"></a> [part\_log\_retention\_time](#input\_part\_log\_retention\_time) | Part log retention time | `number` | `86400000` | no |
| <a name="input_parts_to_delay_insert"></a> [parts\_to\_delay\_insert](#input\_parts\_to\_delay\_insert) | Parts to delay insert | `number` | `150` | no |
| <a name="input_parts_to_throw_insert"></a> [parts\_to\_throw\_insert](#input\_parts\_to\_throw\_insert) | Parts to throw insert | `number` | `300` | no |
| <a name="input_query_log_retention_size"></a> [query\_log\_retention\_size](#input\_query\_log\_retention\_size) | Query log retention size | `number` | `1073741824` | no |
| <a name="input_query_log_retention_time"></a> [query\_log\_retention\_time](#input\_query\_log\_retention\_time) | Query log retention time | `number` | `86400000` | no |
| <a name="input_query_thread_log_enabled"></a> [query\_thread\_log\_enabled](#input\_query\_thread\_log\_enabled) | Query thread log enabled | `bool` | `true` | no |
| <a name="input_query_thread_log_retention_size"></a> [query\_thread\_log\_retention\_size](#input\_query\_thread\_log\_retention\_size) | Query thread log retention size | `number` | `536870912` | no |
| <a name="input_query_thread_log_retention_time"></a> [query\_thread\_log\_retention\_time](#input\_query\_thread\_log\_retention\_time) | Query thread log retention time | `number` | `86400000` | no |
| <a name="input_quota_errors"></a> [quota\_errors](#input\_quota\_errors) | Quota errors | `number` | `1000` | no |
| <a name="input_quota_interval_duration"></a> [quota\_interval\_duration](#input\_quota\_interval\_duration) | Quota interval duration | `number` | `3600000` | no |
| <a name="input_quota_queries"></a> [quota\_queries](#input\_quota\_queries) | Quota queries | `number` | `10000` | no |
| <a name="input_rabbitmq_password"></a> [rabbitmq\_password](#input\_rabbitmq\_password) | RabbitMQ password | `string` | `"rabbit_pass"` | no |
| <a name="input_rabbitmq_username"></a> [rabbitmq\_username](#input\_rabbitmq\_username) | RabbitMQ username | `string` | `"rabbit_user"` | no |
| <a name="input_read_overflow_mode"></a> [read\_overflow\_mode](#input\_read\_overflow\_mode) | Read overflow mode | `string` | `"throw"` | no |
| <a name="input_replicated_deduplication_window"></a> [replicated\_deduplication\_window](#input\_replicated\_deduplication\_window) | Replicated deduplication window | `number` | `100` | no |
| <a name="input_replicated_deduplication_window_seconds"></a> [replicated\_deduplication\_window\_seconds](#input\_replicated\_deduplication\_window\_seconds) | Replicated deduplication window seconds | `number` | `604800` | no |
| <a name="input_resource_preset_id"></a> [resource\_preset\_id](#input\_resource\_preset\_id) | The ID of the preset for computational resources available to a ClickHouse host | `string` | `"s3-c2-m8"` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | Service account ID | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet, to which the host belongs. The subnet must be a part of the network to which the cluster belongs | `string` | n/a | yes |
| <a name="input_text_log_enabled"></a> [text\_log\_enabled](#input\_text\_log\_enabled) | Text log enabled | `bool` | `true` | no |
| <a name="input_text_log_level"></a> [text\_log\_level](#input\_text\_log\_level) | Text log level | `string` | `"TRACE"` | no |
| <a name="input_text_log_retention_size"></a> [text\_log\_retention\_size](#input\_text\_log\_retention\_size) | Text log retention size | `number` | `536870912` | no |
| <a name="input_text_log_retention_time"></a> [text\_log\_retention\_time](#input\_text\_log\_retention\_time) | Text log retention time | `number` | `86400000` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone | `string` | `"UTC"` | no |
| <a name="input_trace_log_enabled"></a> [trace\_log\_enabled](#input\_trace\_log\_enabled) | Trace log enabled | `bool` | `true` | no |
| <a name="input_trace_log_retention_size"></a> [trace\_log\_retention\_size](#input\_trace\_log\_retention\_size) | Trace log retention size | `number` | `536870912` | no |
| <a name="input_trace_log_retention_time"></a> [trace\_log\_retention\_time](#input\_trace\_log\_retention\_time) | Trace log retention time | `number` | `86400000` | no |
| <a name="input_uncompressed_cache_size"></a> [uncompressed\_cache\_size](#input\_uncompressed\_cache\_size) | Uncompressed cache size | `number` | `8589934592` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | User name | `string` | `"user"` | no |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | User password | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Yandex Cloud zone | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_clickhouse_config"></a> [clickhouse\_config](#output\_clickhouse\_config) | Configuration of the ClickHouse subcluster |
| <a name="output_cloud_storage_enabled"></a> [cloud\_storage\_enabled](#output\_cloud\_storage\_enabled) | Whether to use Yandex Object Storage for storing ClickHouse data |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Timestamp of cluster creation |
| <a name="output_databases"></a> [databases](#output\_databases) | A list of databases in the ClickHouse cluster |
| <a name="output_deletion_protection"></a> [deletion\_protection](#output\_deletion\_protection) | Inhibits deletion of the cluster |
| <a name="output_description"></a> [description](#output\_description) | Description of the ClickHouse cluster |
| <a name="output_environment"></a> [environment](#output\_environment) | Deployment environment of the ClickHouse cluster |
| <a name="output_folder_id"></a> [folder\_id](#output\_folder\_id) | ID of the folder that the resource belongs to |
| <a name="output_format_schemas"></a> [format\_schemas](#output\_format\_schemas) | A list of format schemas in the ClickHouse cluster |
| <a name="output_hosts"></a> [hosts](#output\_hosts) | A list of hosts in the ClickHouse cluster |
| <a name="output_id"></a> [id](#output\_id) | ID of the ClickHouse cluster |
| <a name="output_labels"></a> [labels](#output\_labels) | A set of key/value label pairs to assign to the ClickHouse cluster |
| <a name="output_maintenance_window"></a> [maintenance\_window](#output\_maintenance\_window) | Maintenance policy of the ClickHouse cluster |
| <a name="output_ml_models"></a> [ml\_models](#output\_ml\_models) | A list of machine learning models in the ClickHouse cluster |
| <a name="output_name"></a> [name](#output\_name) | Name of the ClickHouse cluster |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | ID of the network to which the ClickHouse cluster belongs |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | A set of ids of security groups assigned to hosts of the cluster |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | ID of the service account used for access to Yandex Object Storage |
| <a name="output_shard_groups"></a> [shard\_groups](#output\_shard\_groups) | A list of shard groups in the ClickHouse cluster |
| <a name="output_shards"></a> [shards](#output\_shards) | A list of shards in the ClickHouse cluster |
| <a name="output_users"></a> [users](#output\_users) | A list of users in the ClickHouse cluster |
| <a name="output_zookeeper_config"></a> [zookeeper\_config](#output\_zookeeper\_config) | Configuration of the ZooKeeper subcluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/blob/main/LICENSE).

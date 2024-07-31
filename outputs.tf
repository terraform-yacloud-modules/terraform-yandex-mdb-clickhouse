output "id" {
  description = "ID of the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.id
}

output "name" {
  description = "Name of the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.name
}

output "environment" {
  description = "Deployment environment of the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.environment
}

output "network_id" {
  description = "ID of the network to which the ClickHouse cluster belongs"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.network_id
}

output "folder_id" {
  description = "ID of the folder that the resource belongs to"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.folder_id
}

output "description" {
  description = "Description of the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.description
}

output "labels" {
  description = "A set of key/value label pairs to assign to the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.labels
}

output "security_group_ids" {
  description = "A set of ids of security groups assigned to hosts of the cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.security_group_ids
}

output "deletion_protection" {
  description = "Inhibits deletion of the cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.deletion_protection
}

output "clickhouse_config" {
  description = "Configuration of the ClickHouse subcluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.clickhouse
  sensitive   = true
}

output "zookeeper_config" {
  description = "Configuration of the ZooKeeper subcluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.zookeeper
}

output "databases" {
  description = "A list of databases in the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.database
}

output "users" {
  description = "A list of users in the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.user
  sensitive   = true
}

output "hosts" {
  description = "A list of hosts in the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.host
}

output "shards" {
  description = "A list of shards in the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.shard
}

output "shard_groups" {
  description = "A list of shard groups in the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.shard_group
}

output "format_schemas" {
  description = "A list of format schemas in the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.format_schema
}

output "ml_models" {
  description = "A list of machine learning models in the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.ml_model
}

output "service_account_id" {
  description = "ID of the service account used for access to Yandex Object Storage"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.service_account_id
}

output "cloud_storage_enabled" {
  description = "Whether to use Yandex Object Storage for storing ClickHouse data"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.cloud_storage.0.enabled
}

output "maintenance_window" {
  description = "Maintenance policy of the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.maintenance_window
}

output "created_at" {
  description = "Timestamp of cluster creation"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.created_at
}

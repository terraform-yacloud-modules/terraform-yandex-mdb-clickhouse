output "id" {
  description = "ID of the ClickHouse cluster"
  value       = module.clickhouse.id
}

output "name" {
  description = "Name of the ClickHouse cluster"
  value       = module.clickhouse.name
}

output "environment" {
  description = "Deployment environment of the ClickHouse cluster"
  value       = module.clickhouse.environment
}

output "network_id" {
  description = "ID of the network to which the ClickHouse cluster belongs"
  value       = module.clickhouse.network_id
}

output "folder_id" {
  description = "ID of the folder that the resource belongs to"
  value       = module.clickhouse.folder_id
}

output "description" {
  description = "Description of the ClickHouse cluster"
  value       = module.clickhouse.description
}

output "labels" {
  description = "A set of key/value label pairs to assign to the ClickHouse cluster"
  value       = module.clickhouse.labels
}

output "security_group_ids" {
  description = "A set of ids of security groups assigned to hosts of the cluster"
  value       = module.clickhouse.security_group_ids
}

output "deletion_protection" {
  description = "Inhibits deletion of the cluster"
  value       = module.clickhouse.deletion_protection
}

output "clickhouse_config" {
  description = "Configuration of the ClickHouse subcluster"
  value       = module.clickhouse.clickhouse_config
  sensitive   = true
}

output "zookeeper_config" {
  description = "Configuration of the ZooKeeper subcluster"
  value       = module.clickhouse.zookeeper_config
}

output "databases" {
  description = "A list of databases in the ClickHouse cluster"
  value       = module.clickhouse.databases
}

output "users" {
  description = "A list of users in the ClickHouse cluster"
  value       = module.clickhouse.users
  sensitive   = true
}

output "hosts" {
  description = "A list of hosts in the ClickHouse cluster"
  value       = module.clickhouse.hosts
}

output "shards" {
  description = "A list of shards in the ClickHouse cluster"
  value       = module.clickhouse.shards
}

output "shard_groups" {
  description = "A list of shard groups in the ClickHouse cluster"
  value       = module.clickhouse.shard_groups
}

output "format_schemas" {
  description = "A list of format schemas in the ClickHouse cluster"
  value       = module.clickhouse.format_schemas
}

output "ml_models" {
  description = "A list of machine learning models in the ClickHouse cluster"
  value       = module.clickhouse.ml_models
}

output "service_account_id" {
  description = "ID of the service account used for access to Yandex Object Storage"
  value       = module.clickhouse.service_account_id
}

output "cloud_storage_enabled" {
  description = "Whether to use Yandex Object Storage for storing ClickHouse data"
  value       = module.clickhouse.cloud_storage_enabled
}

output "maintenance_window" {
  description = "Maintenance policy of the ClickHouse cluster"
  value       = module.clickhouse.maintenance_window
}

output "created_at" {
  description = "Timestamp of cluster creation"
  value       = module.clickhouse.created_at
}

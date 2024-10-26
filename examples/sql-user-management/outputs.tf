output "cluster_id" {
  description = "The ID of the ClickHouse cluster."
  value       = module.clickhouse.cluster_id
}

output "cluster_name" {
  description = "The name of the ClickHouse cluster."
  value       = module.clickhouse.cluster_name
}

output "cluster_host_zones_list" {
  description = "The cluster_host_zones_list of the ClickHouse cluster."
  value       = module.clickhouse.cluster_host_zones_list
}

output "cluster_fqdns_list" {
  description = "The fully qualified domain name (FQDN) of the ClickHouse cluster."
  value       = module.clickhouse.cluster_fqdns_list
}

output "cluster_users" {
  description = "The list of users created in the ClickHouse cluster."
  value       = module.clickhouse.cluster_users
  sensitive   = true
}

output "databases" {
  description = "The list of databases created in the ClickHouse cluster."
  value       = module.clickhouse.databases
}

output "connection" {
  description = "The connection in which the ClickHouse cluster is deployed."
  value       = module.clickhouse.connection
}

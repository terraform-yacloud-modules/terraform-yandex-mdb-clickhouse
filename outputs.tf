output "clickhouse_cluster_host" {
  description = "FQDN of the first host in the ClickHouse cluster"
  value       = yandex_mdb_clickhouse_cluster.clickhouse_cluster.host[0].fqdn
}

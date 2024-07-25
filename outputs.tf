output "clickhouse_cluster_host" {
  value = yandex_mdb_clickhouse_cluster.clickhouse_cluster.host[0].fqdn
}

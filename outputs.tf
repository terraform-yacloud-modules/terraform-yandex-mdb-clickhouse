output "cluster_id" {
  description = "ClickHouse cluster ID."
  value       = yandex_mdb_clickhouse_cluster.this.id
}

output "cluster_name" {
  description = "ClickHouse cluster name."
  value       = yandex_mdb_clickhouse_cluster.this.name
}

output "cluster_host_zones_list" {
  description = "ClickHouse cluster host zones."
  value       = [yandex_mdb_clickhouse_cluster.this.host[*].zone]
}

output "cluster_fqdns_list" {
  description = "ClickHouse cluster nodes FQDN list."
  value       = [yandex_mdb_clickhouse_cluster.this.host[*].fqdn]
}

output "cluster_users" {
  sensitive   = true
  description = "A list of users with passwords."
  value = [
    for u in yandex_mdb_clickhouse_cluster.this.user[*] : {
      user     = u["name"]
      password = u["password"]
    }
  ]
}

output "databases" {
  description = "A list of databases names."
  value       = [for db in var.databases : db.name]
}

output "connection" {
  description = <<EOF
    How connect to ClickHouse cluster?

    1. Install certificate

      mkdir -p /usr/local/share/ca-certificates/Yandex/ && \\
      wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" -O /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt && \\
      chmod 0655 /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt

    2. Upload config.

      mkdir --parents ~/.clickhouse-client && \\
      wget "https://storage.yandexcloud.net/doc-files/clickhouse-client.conf.example" -O ~/.clickhouse-client/config.xml

    3. Run connection string from the output value, for example

      clickhouse-client --host rc1a-xxxxxxxxxxxxxxxx.mdb.yandexcloud.net \
                  --secure \
                  --user user_name \
                  --database database_name \
                  --port 9440 \
                  --ask-password
  EOF

  value     = "clickhouse-client --host ${tolist(yandex_mdb_clickhouse_cluster.this.host)[0].fqdn} --port 9440 --secure --ask-password"
  sensitive = true
}

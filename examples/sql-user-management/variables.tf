#
# yandex
#
variable "azs" {
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

#
# naming
#
variable "blank_name" {
  default = "ycmodules"
}
variable "labels" {
  default = {}
}

#
# network
#
variable "subnets" {
  default = {
    public  = [["10.20.0.0/24"], ["10.21.0.0/24"], ["10.22.0.0/24"]]
    private = [["10.23.0.0/24"], ["10.24.0.0/24"], ["10.25.0.0/24"]]
  }
}

variable "clickhouse_clusters" {
  default = {
    "c01" = {
      access = {
        data_lens     = true
        metrika       = false
        web_sql       = true
        serverless    = false
        yandex_query  = false
        data_transfer = false
      }
      users               = []
      databases           = []
      deletion_protection = false

      disk_size          = 10
      disk_type_id       = "network-ssd"
      resource_preset_id = "s2.micro"
      environment        = "PRODUCTION"
      version            = "24.8"
      description        = "ycmodules example"

      sql_user_management     = true
      sql_database_management = true

      zookeeper_disk_size          = null
      zookeeper_disk_type_id       = null
      zookeeper_resource_preset_id = null

      shards = [
        {
          name   = "master01"
          weight = 100
          resources = {
            resource_preset_id = "s2.micro"
            disk_size          = 5
            disk_type_id       = "network-ssd"
          }
        }
      ]
      hosts = [
        {
          shard_name       = "master01"
          type             = "CLICKHOUSE"
          zone             = "ru-central1-a"
          assign_public_ip = false
        }
      ]
      cloud_storage = {
        enabled             = false
        move_factor         = 0
        data_cache_enabled  = true
        data_cache_max_size = 0
      }
      copy_schema_on_new_hosts = true

      backup_window_start = {
        hours   = "12"
        minutes = 00
      }

      maintenance_window_type = "WEEKLY"
      maintenance_window_hour = 1
      maintenance_window_day  = "SUN"
    }
  }
}

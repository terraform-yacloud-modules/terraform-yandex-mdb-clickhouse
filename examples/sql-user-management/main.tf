locals {
  zone2prvsubnet = {
    for item in module.network.private_subnets : item.zone => item.id
  }
  zone2pubsubnet = {
    for item in module.network.public_subnets : item.zone => item.id
  }

  clickhouse_clusters = {
    for k, v in var.clickhouse_clusters : k => {
      access              = v["access"]
      users               = v["users"]
      databases           = v["databases"]
      deletion_protection = v["deletion_protection"]

      clickhouse_disk_size          = v["disk_size"]
      clickhouse_disk_type_id       = v["disk_type_id"]
      clickhouse_resource_preset_id = v["resource_preset_id"]
      environment                   = v["environment"]
      clickhouse_version            = v["version"]
      description                   = v["description"]

      sql_user_management     = v["sql_user_management"]
      sql_database_management = v["sql_database_management"]

      shards = v["shards"]
      hosts = [
        for obj in v["hosts"] : {
          type             = obj["type"]
          zone             = obj["zone"]
          subnet_id        = lookup(obj, "assign_public_ip", false) ? local.zone2pubsubnet[obj["zone"]] : local.zone2prvsubnet[obj["zone"]]
          assign_public_ip = lookup(obj, "assign_public_ip", null)
        }
      ]

      cloud_storage            = v["cloud_storage"]
      copy_schema_on_new_hosts = v["copy_schema_on_new_hosts"]

      backup_window_start = v["backup_window_start"]

      maintenance_window_type = v["maintenance_window_type"]
      maintenance_window_hour = v["maintenance_window_hour"]
      maintenance_window_day  = v["maintenance_window_day"]
    }
  }
}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.7.0"

  blank_name = var.blank_name
  labels     = var.labels

  azs = var.azs

  create_nat_gateway = true

  public_subnets  = var.subnets["public"]
  private_subnets = var.subnets["private"]
}

module "clickhouse" {
  for_each = local.clickhouse_clusters

  source = "../../"

  name   = format("%s-%s", var.blank_name, each.key)
  labels = var.labels

  network_id         = module.network.vpc_id
  security_group_ids = []

  access              = each.value["access"]
  users               = each.value["users"]
  databases           = each.value["databases"]
  deletion_protection = each.value["deletion_protection"]

  clickhouse_disk_size          = each.value["clickhouse_disk_size"]
  clickhouse_disk_type_id       = each.value["clickhouse_disk_type_id"]
  clickhouse_resource_preset_id = each.value["clickhouse_resource_preset_id"]
  environment                   = each.value["environment"]
  clickhouse_version            = each.value["clickhouse_version"]
  description                   = each.value["description"]

  sql_user_management     = each.value["sql_user_management"]
  sql_database_management = each.value["sql_database_management"]
  admin_password          = each.value["sql_user_management"] ? random_password.clickhouse_admin_password[each.key].result : null

  shards                   = each.value["shards"]
  hosts                    = each.value["hosts"]
  cloud_storage            = each.value["cloud_storage"]
  copy_schema_on_new_hosts = each.value["copy_schema_on_new_hosts"]

  backup_window_start = each.value["backup_window_start"]
  maintenance_window = {
    type = each.value["maintenance_window_type"]
    day  = each.value["maintenance_window_day"]
    hour = each.value["maintenance_window_hour"]
  }
  depends_on = [module.network]
}


resource "random_password" "clickhouse_admin_password" {
  for_each = {
    for k, v in local.clickhouse_clusters : k => v if v["sql_user_management"]
  }

  length           = 8
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "clickhouse_secrets" {
  for_each = {
    for k, v in local.clickhouse_clusters : k => v if v["sql_user_management"]
  }

  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-lockbox.git?ref=v1.0.0"

  name   = format("%s-clickhouse-%s", var.blank_name, each.key)
  labels = var.labels

  entries = {
    "admin-password" : random_password.clickhouse_admin_password[each.key].result
  }

  deletion_protection = false
}

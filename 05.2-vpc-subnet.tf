resource "yandex_vpc_network" "vpc-net-01" {
  name        = "vpc-net-01"
}

resource "yandex_vpc_subnet" "ru-central1-a" {
  name           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.vpc-net-01.id}"
  #route_table_id = yandex_vpc_route_table.nat-instance-route.id
}
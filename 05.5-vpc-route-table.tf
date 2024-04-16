resource "yandex_vpc_route_table" "nat-gateway-rt" {
  name       = "nat-gateway-rt"
  network_id = yandex_vpc_network.vpc-net-01.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}
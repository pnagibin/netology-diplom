resource "yandex_vpc_gateway" "nat-gateway" {
  folder_id      = var.folder_id
  name = "nat-gateway"
  shared_egress_gateway {}
}
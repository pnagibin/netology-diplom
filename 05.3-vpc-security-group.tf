resource "yandex_vpc_security_group" "nat-instance-sg" {
  name       = var.sg_nat_name
  network_id = yandex_vpc_network.vpc-net-01.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "ICMP"
    description    = "ext-ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

    ingress {
    protocol       = "Any"
    description    = "any"
    v4_cidr_blocks = ["192.168.1.0/24"]
    from_port      = 0
    to_port        = 65535
  }

}
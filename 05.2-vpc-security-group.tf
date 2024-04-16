resource "yandex_vpc_security_group" "nat-gateway-sg" {
  name       = "nat-gateway-sg"
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
    description    = "webserver-ext"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "webserver-int"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30010
  } 

  ingress {
    protocol       = "TCP"
    description    = "grafana-ext"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 3000
  }

    ingress {
    protocol       = "TCP"
    description    = "grafana-int"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30007
  }

  ingress {
    protocol       = "TCP"
    description    = "prometheus-ext"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 9090
  }

  ingress {
    protocol       = "TCP"
    description    = "prometheus-int"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30008
  }

  ingress {
    protocol       = "TCP"
    description    = "alertmanager-ext"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 9093
  }

  ingress {
    protocol       = "TCP"
    description    = "alertmanager-int"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30009
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
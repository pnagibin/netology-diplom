resource "yandex_lb_network_load_balancer" "loadbalancer-01" {
  name = "loadbalancer-01"

  listener {
    name = "listener-grafana"
    port = 3000
    target_port = 30007
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name = "listener-prometheus"
    port = 9090
    target_port = 30008
    external_address_spec {
      ip_version = "ipv4"
    }
  }

    listener {
    name = "listener-alertmanager"
    port = 9093
    target_port = 30009
    external_address_spec {
      ip_version = "ipv4"
    }
  }

    listener {
    name = "listener-webserver"
    port = 80
    target_port = 30010
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lb-target-group-01.id
    healthcheck {
      name = "http"
      tcp_options {
        port = 30010
      }
    }
  }
}
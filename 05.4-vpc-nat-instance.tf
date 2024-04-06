data "yandex_compute_image" "nat-instance-ubuntu-2204" {
  family = "nat-instance-ubuntu-2204"
}

resource "yandex_compute_instance" "nat-instance" {
  for_each = { for vm in var.vm_nat_instance : vm.vm_name => vm }
  name        = each.key
  platform_id = each.value.platform_id
  zone          = each.value.zone
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }
  boot_disk {
    initialize_params {
      size = 10
      image_id = data.yandex_compute_image.nat-instance-ubuntu-2204.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.ru-central1-a.id}"
    security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
    nat        = true
    ipv4       = true
    ip_address = "192.168.1.254"
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("04.2-cloud-init.yaml")}"
  }
}
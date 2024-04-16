resource "yandex_lb_target_group" "lb-target-group-01" {
  name      = "lb-target-group-01"
  
  dynamic "target" {
    for_each = [ for vm in yandex_compute_instance.kubernetes-workers : { address = vm.network_interface.0.ip_address }]
    content {
      subnet_id = "${yandex_vpc_subnet.ru-central1-b.id}"
      address   = target.value.address
    }
  }
}
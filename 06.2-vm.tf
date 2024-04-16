data "yandex_compute_image" "ubuntu-2204-lts" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "kubernetes-masters" {
  for_each = { for vm in var.vm_kube_masters : vm.vm_name => vm }
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
      image_id = data.yandex_compute_image.ubuntu-2204-lts.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.ru-central1-b.id}"
    nat       = false
    security_group_ids = [yandex_vpc_security_group.nat-gateway-sg.id]
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("04.2-cloud-init.yaml")}"
  }
}

resource "yandex_compute_instance" "kubernetes-workers" {
  for_each = { for vm in var.vm_kube_workers : vm.vm_name => vm }
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
      image_id = data.yandex_compute_image.ubuntu-2204-lts.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.ru-central1-b.id}"
    nat       = false
    security_group_ids = [yandex_vpc_security_group.nat-gateway-sg.id]
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("04.2-cloud-init.yaml")}"
  }
}

resource "yandex_compute_instance" "ansible" {
  depends_on = [yandex_compute_instance.kubernetes-masters, yandex_compute_instance.kubernetes-workers]
  for_each = { for vm in var.vm_ansible : vm.vm_name => vm }
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
      image_id = data.yandex_compute_image.ubuntu-2204-lts.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.ru-central1-b.id}"
    nat       = true
    security_group_ids = [yandex_vpc_security_group.nat-gateway-sg.id]
  }

  metadata = {
    serial-port-enable = 1
    user-data = "${file("04.2-cloud-init.yaml")}"
  }
  connection {
    type        = "ssh"
    user        = "nagibin"
    private_key = "${file("/root/.ssh/id_ed25519")}"
    host        = "${self.network_interface.0.nat_ip_address}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt update -y",
      "sudo apt install ansible -y",
      "mkdir /home/nagibin/ansible"
    ]
  }
  provisioner "file" {
    source      = "${abspath(path.module)}/ansible/"
    destination = "/home/nagibin/ansible"
  }
 
  provisioner "remote-exec" {
    inline = [
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible -i /home/nagibin/ansible/hosts.cfg -u nagibin all -m ping -v",
      "ansible-playbook -i /home/nagibin/ansible/hosts.cfg -u nagibin ./ansible/kube-prerequisites.yaml -v",
      "ansible-playbook -i /home/nagibin/ansible/hosts.cfg -u nagibin ./ansible/kube-masters.yaml -v",
      "ansible-playbook -i /home/nagibin/ansible/hosts.cfg -u nagibin ./ansible/kube-workers.yaml -v",
      "ansible-playbook -i /home/nagibin/ansible/hosts.cfg -u nagibin ./ansible/kube-monitoring.yaml -v",
      "ansible-playbook -i /home/nagibin/ansible/hosts.cfg -u nagibin ./ansible/kube-deployment.yaml -v",
      "ansible-playbook -i /home/nagibin/ansible/hosts.cfg -u nagibin ./ansible/kube-service.yaml -v"
    ]
  }
}

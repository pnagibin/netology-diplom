# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      kubernetes_masters = yandex_compute_instance.kubernetes-masters
      kubernetes_workers = yandex_compute_instance.kubernetes-workers
    }
  )
  filename = "${abspath(path.module)}/ansible/hosts.cfg"
}
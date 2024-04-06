variable "vm_kube_masters" {
  description = "Kubernetes Masters"
  type = list(object({
   vm_name = string
    cpu     = number
    ram     = number
    core_fraction   = number
    platform_id     = string
    zone            = string
  }))
  default = [
    {
       vm_name = "kube-master-01"
      cpu   = 2
      ram   = 2
      core_fraction = 5
      platform_id   = "standard-v1"
      zone          = "ru-central1-a"
    },
  ]
}

variable "vm_kube_workers" {
  description = "Kubernetes Workers"
  type = list(object({
   vm_name = string
    cpu     = number
    ram     = number
    core_fraction   = number
    platform_id     = string
    zone            = string
  }))
  default = [
    {
     vm_name = "kube-worker-01"
      cpu   = 2
      ram   = 2
      core_fraction = 5
      platform_id   = "standard-v1"
      zone          = "ru-central1-a"
    },
    {
     vm_name = "kube-worker-02"
      cpu   = 2
      ram   = 2
      core_fraction = 5
      platform_id   = "standard-v1"
      zone          = "ru-central1-a"
    },
    {
     vm_name = "kube-worker-03"
      cpu   = 2
      ram   = 2
      core_fraction = 5
      platform_id   = "standard-v1"
      zone          = "ru-central1-a"
    }
  ]
}

variable "vm_ansible" {
  description = "Kubernetes Masters"
  type = list(object({
   vm_name = string
    cpu     = number
    ram     = number
    core_fraction   = number
    platform_id     = string
    zone            = string
  }))
  default = [
    {
       vm_name = "ansible"
      cpu   = 2
      ram   = 2
      core_fraction = 5
      platform_id   = "standard-v1"
      zone          = "ru-central1-a"
    },
  ]
}
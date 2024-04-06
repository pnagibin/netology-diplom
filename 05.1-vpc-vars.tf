variable "sg_nat_name" {
  type        = string
  default     = "nat-instance-sg"
}

variable "route_table_name" {
  type        = string
  default     = "nat-instance-route"
}

variable "vm_nat_instance" {
  description = "nat instance var"
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
       vm_name = "nat-instance"
      cpu   = 2
      ram   = 2
      core_fraction = 5
      platform_id   = "standard-v1"
      zone          = "ru-central1-a"
    }
  ]
}
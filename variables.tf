variable "vm_name" {
    type = string
    description = "The name of the virtual machine"
  }
variable "admin_username" {
  type = string
  description = "The user name of the virtual machine"
}

variable "vm_size" {
    type = string
    description = "Size of the virtual machine"
  
}

variable "container" {
  default = {
    container1 = "devops"
    container2 = "infra-devops"
  }
}
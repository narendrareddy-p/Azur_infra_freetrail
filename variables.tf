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

variable "app_subnets" {
    default = {
        subnet1 = {
            name = "devops-opertaion"
            address_prefixes = ["10.0.1.17/28"]
        }
        subnet2 = {
            name = "infra-operation"
            address_prefixes = ["10.0.1.33/28"]
        }
    } 

  
}
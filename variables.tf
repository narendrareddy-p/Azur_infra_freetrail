variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_groups" {
  description = "Map of resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
}
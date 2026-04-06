variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  description = "Tags for RG"
  type        = map(string)
  default     = {}
}


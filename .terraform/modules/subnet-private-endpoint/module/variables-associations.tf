variable "enable_route_table" {
  type        = bool
  description = "Should 'route table' be enabled for the subnet"
  default     = false
}

variable "route_table_name" {
  type        = string
  description = "Specify the name of the Route Table  to associate with"
  default     = null
  nullable    = true
}

variable "route_table_resource_group_name" {
  type        = string
  description = "Specify the name of the Resource Group in which the Route Table is located"
  default     = null
  nullable    = true
}


variable "enable_nat_gateway" {
  type        = bool
  description = "Should 'NAT gateway' be enabled for the subnet"
  default     = false
}

variable "nat_gateway_name" {
  type        = string
  description = "Specify the name of the NAT Gateway to associate with"
  default     = null
  nullable    = true
}

variable "nat_gateway_resource_group_name" {
  type        = string
  description = "Specify the name of the Resource Group in which the NAT Gateway is located"
  default     = null
  nullable    = true
}

variable "enable_network_security_group" {
  type        = bool
  description = "Should 'Network Security Group' be enabled for the subnet"
  default     = true
}

variable "network_security_group_name" {
  type        = string
  description = "Specify the name of the NAT Gateway to associate with"
  default     = null
  nullable    = true
}

variable "network_security_group_resource_group_name" {
  type        = string
  description = "Specify the name of the Resource Group in which the NAT Gateway is located"
  default     = null
  nullable    = true
}
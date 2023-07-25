variable "virtual_network_name" {
  description = "(Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the name of the resource group in which to create the subnets. Changing this forces new resources to be created."
  nullable    = false
}

variable "address_prefixes" {
  type        = list(string)
  description = "(Required) The address prefixes to use for the subnet."
}

variable "private_endpoint_network_policies_enabled" {
  type        = bool
  description = "Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
  default     = true
}

variable "private_link_service_network_policies_enabled" {
  type        = bool
  description = "Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
  default     = true
}

variable "service_endpoints" {
  type        = list(string)
  description = "The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web."
  default     = null
}

variable "service_endpoint_policy_ids" {
  type        = list(string)
  description = "The list of IDs of Service Endpoint Policies to associate with the subnet."
  default     = null
}

variable "enable_delegation" {
  type        = bool
  description = "Should 'delegation' be enabled for the subnet"
  default     = true
}

variable "delegation_name" {
  type        = string
  description = "The name given to the delegation that will be created."
  default     = null
}

variable "network_security_group_id" {
  type        = string
  description = "The network security group id."
  default     = null
}

variable "route_table_id" {
  type        = string
  description = "The route table id."
  default     = null
}

variable "nat_gateway_id" {
  type        = string
  description = "The route table id."
  default     = null
}

variable "service_delegation_name" {
  type        = string
  description = "The name of the service to whom the subnet should be delegated (e.g. Microsoft.Web/serverFarms)"
  default     = null
}

variable "service_delegation_actions" {
  type        = list(string)
  description = "A list of Actions which should be delegated. This list is specific to the service to delegate to."
  default     = null
}
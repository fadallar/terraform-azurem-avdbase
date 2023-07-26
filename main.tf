locals {

  ### Base Resources
  stack             = "avdpoc"
  landing_zone_slug = "tbd"
  location          = "westeurope"

  # specify base tagging values
  environment     = "poc"
  application     = "avd"
  cost_center     = "ECTL-EU"
  change          = ""
  owner           = ""
  spoc            = ""
  tlp_colour      = "WHITE"
  cia_rating      = ""
  technical_owner = ""

  ### Networking

  virtual_network_address_space = ["10.0.0.0/16"]
  subnet                        = ["10.0.1.0/24"]
  subnet_private_endpoint       = ["10.0.2.0/24"]

  storage_account_domain_name = "privatelink.blob.core.windows.net"
  keyvault_domain_name = "privatelink.vaultcore.azure.net"

  ### Supporting Services

  file_share_quota       = 50
  file_share_access_tier = "TransactionOptimized"

  ### Virtual Machine

  vm_hostname = "testvm"

}

data "azurerm_client_config" "current" {
}

####   Base Resources

module "regions" {
  source       = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-regions//module?ref=release/1.0.0"
  azure_region = local.location
}

module "base_tagging" {
  source          = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-basetagging//module?ref=1.1.0"
  environment     = local.environment
  application     = local.application
  cost_center     = local.cost_center
  change          = local.change
  owner           = local.owner
  spoc            = local.spoc
  tlp_colour      = local.tlp_colour
  cia_rating      = local.cia_rating
  technical_owner = local.technical_owner
}

module "resource_group" {
  source            = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-resourcegroup//module?ref=release/1.0.0"
  stack             = local.stack
  landing_zone_slug = local.landing_zone_slug
  default_tags      = module.base_tagging.base_tags
  location          = module.regions.location
  location_short    = module.regions.location_short
  environment       = local.environment
}

module "diag_log_analytics_workspace" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-loganalyticsworkspace//module?ref=master"

  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags

}

####  Networking

module "vnet" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-vnet//module?ref=develop"

  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  virtual_network_address_space           = local.virtual_network_address_space
  virtual_network_flow_timeout_in_minutes = 4


}

module "private_dns_zone_st_account" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-terraform-azurerm-privatednszone//module?ref=release/1.0.0"

  domain_name         = local.storage_account_domain_name
  resource_group_name = module.resource_group.resource_group_name
  default_tags = module.base_tagging.base_tags
  
}

module "private_dns_zone_keyvault" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-terraform-azurerm-privatednszone//module?ref=release/1.0.0"

  domain_name         = local.keyvault_domain_name
  resource_group_name = module.resource_group.resource_group_name
  default_tags = module.base_tagging.base_tags
  
}

module "route_table" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-routetable//module?ref=release/1.0.0"

  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags
  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack

}

module "subnet" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-subnet//module?ref=develop"

  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name

  virtual_network_name = module.vnet.virtual_network_name
  address_prefixes     = local.subnet
  //route_table_id       = module.route_table.route_table_id
  enable_delegation    = false
  //network_security_group_id               = 
}

module "subnet-private-endpoint" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-subnet//module?ref=develop"

  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name

  virtual_network_name = module.vnet.virtual_network_name
  address_prefixes     = local.subnet_private_endpoint
  //route_table_id       = module.route_table.route_table_id
  enable_delegation    = false

  //network_security_group_id               = 
}

module "nsg" {
  source              = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-nsg//module?ref=release/1.0.0"
  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags
  security_rules      = []
}

### Supporting Services


module "keyvault" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-keyvault//module?ref=release/1.0.0"

  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  tenant_id = data.azurerm_client_config.current.tenant_id

  private_dns_zone_id        = module.private_dns_zone_keyvault.id
  private_endpoint_subnet_id = module.subnet-private-endpoint.subnet_id

  network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

module "storage_account" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-blobstorage//module?ref=release/1.0.0"

  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id


  private_dns_zone_id = module.private_dns_zone_keyvault.id
  private_endpoint_subnet_id = module.subnet-private-endpoint.subnet_id

  storage_blob_data_protection = {
    "change_feed_enabled" : false,
    "container_delete_retention_policy_in_days" : 7,
    "container_point_in_time_restore" : false,
    "delete_retention_policy_in_days" : 7,
    "versioning_enabled" : false
  }

  containers = []

}

module "file_share" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-storageshare//module?ref=release/1.0.0"

  landing_zone_slug = local.landing_zone_slug
  stack             = local.stack
  location_short    = module.regions.location_short

  storage_account_name = module.storage_account.storage_account_name
  quota                = local.file_share_quota
  access_tier          = local.file_share_access_tier


}


### Virtual Machine


module "vmwindows" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-vmwindows//module?ref=release/1.0.0"

  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags
  environment         = local.environment

  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  hostname  = local.vm_hostname
  subnet_id = module.subnet.subnet_id

  network_security_group_id = module.nsg.nsg_id

}
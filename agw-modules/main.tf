provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}


module "appgw" {
  source                = "./modules/appgw"
  resource_group_name   = var.resource_group_name
  location              = var.location
  virtual_network_name  = var.virtual_network_name
  subnet_name           = var.subnet_name
  subnet_cidr           = var.subnet_cidr
  public_ip_name        = var.public_ip_name
  appgw_name            = var.appgw_name
  backend_vm_private_ip = var.backend_vm_private_ip
}

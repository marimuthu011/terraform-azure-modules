# Resource Group
resource "azurerm_resource_group" "appaw" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "appaw_vnet" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.appaw.location
  resource_group_name = azurerm_resource_group.appaw.name
  address_space       = ["10.0.0.0/16"]
}



resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.appaw.name
  virtual_network_name = azurerm_virtual_network.appaw_vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.appaw.name
  location            = azurerm_resource_group.appaw.location
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "network" {
  name                = var.appgw_name
  resource_group_name = azurerm_resource_group.appaw.name
  location            = azurerm_resource_group.appaw.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.subnet.id
  }

  frontend_port {
    name = "appgw-frontend"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  backend_address_pool {
    name         = "appgw-backend-address-pool"
    ip_addresses = [var.backend_vm_private_ip]
  }

  backend_http_settings {
    name                  = "appgw-backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "frontend-ip-configuration"
    frontend_port_name             = "appgw-frontend"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "appgw-request-routing-rule"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "appgw-http-listener"
    backend_address_pool_name  = "appgw-backend-address-pool"
    backend_http_settings_name = "appgw-backend-http-settings"
  }
}

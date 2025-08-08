# Resource Group
resource "azurerm_resource_group" "redis" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "redis_vnet" {
  name                = "vnet-redis"
  location            = azurerm_resource_group.redis.location
  resource_group_name = azurerm_resource_group.redis.name
  address_space       = ["10.10.0.0/16"]
}

# Subnet for Private Endpoint
resource "azurerm_subnet" "privateendpoint" {
  name                 = "subnet-private-endpoint"
  resource_group_name  = azurerm_resource_group.redis.name
  virtual_network_name = azurerm_virtual_network.redis_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

# Premium Redis Cache
resource "azurerm_redis_cache" "terraform_redis" {
  name                = "priv-redis-cache-001"
  location            = azurerm_resource_group.redis.location
  resource_group_name = azurerm_resource_group.redis.name
  capacity            = 1
  family              = "P"
  sku_name            = "Premium"
  minimum_tls_version = "1.2"
}

# Private Endpoint for Redis
resource "azurerm_private_endpoint" "redis" {
  name                = "redis-private-endpoint"
  location            = azurerm_resource_group.redis.location
  resource_group_name = azurerm_resource_group.redis.name
  subnet_id           = azurerm_subnet.privateendpoint.id

  private_service_connection {
    name                           = "redis-priv-conn"
    private_connection_resource_id = azurerm_redis_cache.terraform_redis.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }
}

# Private DNS zone
resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.redis.name
}

# Link DNS zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "redis-dnslink"
  resource_group_name   = azurerm_resource_group.redis.name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = azurerm_virtual_network.redis_vnet.id
}

# DNS A record
resource "azurerm_private_dns_a_record" "redis" {
  name                = azurerm_redis_cache.terraform_redis.name
  zone_name           = azurerm_private_dns_zone.redis.name
  resource_group_name = azurerm_resource_group.redis.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.redis.private_service_connection[0].private_ip_address]
}

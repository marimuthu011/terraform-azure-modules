variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  sensitive   = true
}

variable "client_id" {
  type        = string
  description = "Azure Client ID"
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Azure Client Secret"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Azure Region"
  default     = "Central India"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "rg-app-gateway"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
  default     = "vnet-app-gateway"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet for the Application Gateway"
  default     = "subnet-app-gateway"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR for the Application Gateway subnet"
  default     = "10.0.1.0/24"
}

variable "public_ip_name" {
  type        = string
  description = "Name of the public IP for the Application Gateway"
  default     = "appgw-public-ip"
}

variable "appgw_name" {
  type        = string
  description = "Name of the Application Gateway"
  default     = "appgw-redis"
}

variable "backend_vm_private_ip" {
  type        = string
  description = "Private IP address of the backend VM"
  default    = "10.0.0.4"
}


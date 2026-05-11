variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
}

variable "sql_server_fqdn" {
  description = "SQL Server fully qualified domain name"
  type        = string
}

variable "sql_database_name" {
  description = "SQL Database name"
  type        = string
}

variable "key_vault_uri" {
  description = "Key Vault URI for secret references"
  type        = string
}

variable "env" {
  description = "Environment descriptor"
  type        = string
}

variable "frontend_url" {
  description = "Frontend application URL for CORS configuration"
  type        = string
  default     = ""
}

variable "suffix" {
  description = "Random suffix for resource naming"
  type        = string
}


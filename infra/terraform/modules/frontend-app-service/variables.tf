variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "service_plan_id" {
  description = "ID of the shared App Service Plan (created by the API module)"
  type        = string
}

variable "api_base_url" {
  description = "Base URL of the API backend"
  type        = string
}

variable "environment" {
  description = "Environment suffix"
  type        = string
}
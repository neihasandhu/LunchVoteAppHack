variable "name" {
  description = "A unique name to assign to resources created by this module"
  type        = string
}

variable "env" {
  description = "The environment descriptor into which resources created by this module will be provisioned"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "stg", "prod"], var.env)
    error_message = "The env value must be one of 'dev', 'stg', or 'prod'"
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "australiaeast"
}

variable "sql_admin_object_id" {
  description = "Microsoft Entra ID object ID for SQL admin"
  type        = string
  sensitive   = true
}

variable "sql_admin_login" {
  description = "Microsoft Entra ID login name for SQL admin"
  type        = string
}

variable "deploy_static_web_app" {
  description = "Deploy Static Web App for SPA hosting"
  type        = bool
  default     = false
}

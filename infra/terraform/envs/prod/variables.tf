variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "acr_name" {
  type        = string
  description = "ACR name (global unique, lowercase)"
}

variable "log_analytics_name" {
  type        = string
  description = "Log Analytics Workspace name"
}

variable "aks_name" {
  type        = string
  description = "AKS cluster name"
}

variable "dns_prefix" {
  type        = string
  description = "AKS DNS prefix"
}

variable "node_pool_name" {
  type        = string
  description = "AKS default node pool name"
}

variable "node_count" {
  type        = number
  description = "AKS node count"
}

variable "vm_size" {
  type        = string
  description = "AKS VM size"
}

variable "admin_username" {
  type        = string
  description = "Linux admin username"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for AKS nodes"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}

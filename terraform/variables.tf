variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"  # Default location if not specified
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "environment" {
  description = "Environment (sit, uat, prod)"
  type        = string
  default     = "sit"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Size of the AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes"
  type        = string
  default     = "1.26.3"
}

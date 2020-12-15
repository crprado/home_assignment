variable "env" {
  description = "Environment Prefix."
  type = string
}

variable "resource_group" {
  description = "Resource group to place the services."
  type = string
}

variable "azure_region" {
  description = "The location for the resources."
  type = string
}

variable "kube_cluster_name" {
  description = "The name of the kubernetes cluster."
  type = string
}

variable "kube_cluster_dns_prefix" {
  description = "The DNS prefix for the kubernetes cluster."
  type = string
}

variable "kube_version" {
  description = "Kubenetes version to be used with service"
  type = string
  default = "1.19.3"
}

variable "node_pool_prefix" {
  description = "Prefix associated with kube nodes."
  type = string
}

variable "node_pool_count" {
  description = "The number of nodes to be used in the kubenetes cluster"
  type = string
  default = "1"
}

variable "node_vm_sku" {
  description = "The VM size for the cluster."
  type = string
  default = "Standard_B2s"
}

variable "acr_name" {
  description = "Name for Azure Container Registry"
  type = string
}

variable "external_ip_resource" {
  description = "Name for Azure External IP"
  type = string
}

variable "tags" {
  type = map(string)
  default = {
      Terraform = "true"
  }
}
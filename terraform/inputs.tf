variable "access_group_id" {
  description = "IAM Identity Center access group ID that is authorized to access the private subnets."
  type        = string
}

variable "availability_zone" {
  description = "Availability zone of the subnet to associate with the VPN endpoint."
  type        = string
}

variable "endpoint_name" {
  description = "The name of the VPN endpoint to create."
  type        = string
}

variable "region" {
  description = "(Optional) The AWS region to deploy to. Defaults to ca-central-1."
  type        = string
  default     = "ca-central-1"
}

variable "endpoint_cidr_block" {
  description = "(Optional) The CIDR block to use for the VPN endpoint."
  type        = string
  default     = "172.16.0.0/22"
}
variable "dev_vpc_name" {
  type = string
}

variable "region" {
  type = string
}

variable "dev_cidr_range" {
  type = string
}

## GCE Variables ##
variable "instance_name" {
  type = string
}   

variable "zone" {
  type = string
}

variable "machine_type" {
  type = string
}

## IAM Variables ##
variable "sa_id" {
  type = string
}

variable "project_id" {
  type = string
}
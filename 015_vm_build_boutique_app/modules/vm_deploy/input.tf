variable "vsphere_datacenter" {
  description = "vSphere Datacenter Name"
  type        = string
}

variable "vsphere_compute_cluster" {
  description = "vSphere Cluster Name"
  type        = string
}

variable "vsphere_datastore" {
  description = "vSphere DataStore Name"
  type        = string
}

variable "vsphere_network" {
  description = "vSphere PortGroup Name"
  type        = string
}

variable "vm_template_name" {
  description = "vSphere VM Template Name"
  type        = string
}

variable "vm_name" {
  description = "VM Name"
  type        = string
}

variable "host_name" {
  description = "VM OS hostname"
  type        = string
}

variable "domain" {
  description = "VM OS domain"
  type        = string
}

variable "ip_address" {
  description = "VM IP Address"
  type        = string
}

variable "netmask_cidr" {
  description = "VM Netmask CIDR"
  type        = string
}

variable "gateway" {
  description = "VM Default Gateway"
  type        = string
}

variable "dns_server_list" {
  description = "VM DNS Server List"
}

variable "dns_suffix_list" {
  description = "VM DNS Suffix List"
}

variable "vm_folder" {
  description = "VM Folder Name"
  type        = string
}

variable "num_cpus" {
  description = "No. of CPUs Required"
}

variable "mem_gb" {
  description = "VM Memory Required (GB)"
}

variable "tag_id" {
  description = "VM Tag ID"
  type        = string
}

variable "vm_username" {
  description = "VM Username"
}

variable "vm_password" {
  description = "VM Password"
  sensitive   = true
}

variable "docker_cmd" {
  description = "Docker Command to send to VM"
}
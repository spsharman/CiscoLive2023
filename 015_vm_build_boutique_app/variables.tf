variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vm_username" {
  description = "VM Username"
}

variable "vm_password" {
  description = "VM Password"
  sensitive   = true
}

variable "vsphere_datacenter" {
  description = "vSphere Datacenter"
  type        = string
}
variable "prefix" {
  description = "Service Prefix"
  type        = string
}

variable "vm_folder_root" {
  description = "VM parent folder path"
}


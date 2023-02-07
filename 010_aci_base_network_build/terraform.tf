terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      #   version = "2.1.0"
    }
  }
}

provider "aci" {
  username = var.apic_user
  password = var.apic_password
  url      = var.apic_ip
  insecure = true
}
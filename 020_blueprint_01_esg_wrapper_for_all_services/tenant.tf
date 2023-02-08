data "aci_tenant" "user_tenant" {
  name = local.unmanaged.tenants.user_tenant.name
}

data "aci_tenant" "shared_services_tenant" {
  name = local.unmanaged.tenants.shared_services_tenant.name
}

data "aci_vrf" "user_vrf" {
  tenant_dn = data.aci_tenant.user_tenant.id
  name      = local.unmanaged.tenants.user_tenant.vrf.name
}

data "aci_tenant" "user_tenant" {
  name = local.model.tenant_name
}

data "aci_tenant" "shared_services_tenant" {
  name = local.model.shared_services_tenant_name
}

data "aci_vrf" "user_vrf" {
  tenant_dn = data.aci_tenant.user_tenant.id
  name      = local.model.vrf_name
}

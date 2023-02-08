data "aci_tenant" "user_tenant" {
  name = local.model.data_resource.tenant.name
}

data "aci_vrf" "user_vrf" {
  tenant_dn = data.aci_tenant.user_tenant.id
  name      = local.model.data_resource.tenant.vrf.name
}

data "aci_tenant" "shared_services_tenant" {
  name = local.model.data_resource.shared_services_tenant.name
}

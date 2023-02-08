data "aci_contract" "permit-to-tenant" {
  tenant_dn  = data.aci_tenant.user_tenant.id
  name       = local.model.data_resource.tenant.contract.name
}

resource "aci_application_profile" "app_profile" {
  tenant_dn = data.aci_tenant.user_tenant.id
  name      = local.model.resource.app_profile.name
}

resource "aci_endpoint_security_group" "esg" {
  application_profile_dn = aci_application_profile.app_profile.id
  name                   = local.model.resource.esg.name

  relation_fv_rs_scope   = data.aci_vrf.user_vrf.id

  relation_fv_rs_prov {
    target_dn = data.aci_contract.permit-to-tenant.id
  }
}

resource "aci_endpoint_security_group_epg_selector" "esg_epg_selector" {
  count = length(local.model.resource.esg.epg_selectors)

  endpoint_security_group_dn  = aci_endpoint_security_group.esg.id
  match_epg_dn  = "uni/tn-${data.aci_tenant.user_tenant.name}/ap-${local.model.resource.esg.epg_selectors[count.index].app_profile_name}/epg-${local.model.resource.esg.epg_selectors[count.index].epg_name}"
}
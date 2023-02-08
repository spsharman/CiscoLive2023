###############################
# Application Profile
###############################
resource "aci_application_profile" "all_services_app_profile" {
  tenant_dn = data.aci_tenant.user_tenant.id
  name      = local.managed.app_profile.name
}

resource "aci_endpoint_security_group" "esg" {
  application_profile_dn = aci_application_profile.all_services_app_profile.id
  name                   = local.managed.app_profile.esg.name

  relation_fv_rs_scope   = data.aci_vrf.user_vrf.id

  relation_fv_rs_prov {
    target_dn = "uni/tn-${var.TENANT_NAME}/brc-${aci_contract.permit_to_online_boutique_all_services.name}"
    match_t   = "AtleastOne"
    prio      = "unspecified"
  }
}

resource "aci_endpoint_security_group_tag_selector" "all_services_tag_selector" {
  count = length(local.managed.app_profile.esg.vm_tags)

  endpoint_security_group_dn = aci_endpoint_security_group.esg.id
  match_key                  = local.managed.app_profile.esg.vm_tags[count.index].key
  match_value                = local.managed.app_profile.esg.vm_tags[count.index].value
  value_operator             = "equals"
}

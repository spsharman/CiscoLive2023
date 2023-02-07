###############################
# Application Profile
###############################
resource "aci_application_profile" "all_services_app_profile" {
  tenant_dn = data.aci_tenant.user_tenant.id
  name      = local.model.all_services_app_profile.app_profile_name
}

resource "aci_endpoint_security_group" "esg" {
  application_profile_dn = aci_application_profile.all_services_app_profile.id
  name                   = local.model.all_services_app_profile.esg.name
  pc_enf_pref            = "enforced"
  
  relation_fv_rs_scope   = data.aci_vrf.user_vrf.id

  relation_fv_rs_prov {
    target_dn = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-all-services"
  }

  relation_fv_rs_intra_epg = [aci_contract.permit_to_online_boutique_all_services_isolated.id]

}

resource "aci_endpoint_security_group_tag_selector" "all_services_tag_selector" {
  count = length(local.model.all_services_app_profile.esg_tags)

  endpoint_security_group_dn = aci_endpoint_security_group.esg.id
  match_key                  = local.model.all_services_app_profile.esg_tags[count.index].key
  match_value                = local.model.all_services_app_profile.esg_tags[count.index].value
  value_operator             = "equals"
}

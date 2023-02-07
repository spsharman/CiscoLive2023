###############################
# Application Profile
###############################
resource "aci_application_profile" "all_services_app_profile" {
  tenant_dn = data.aci_tenant.user_tenant.id
  name      = local.model.all_services_app_profile.app_profile_name
}

resource "aci_endpoint_security_group" "esg" {
  count = length(local.model.all_services_app_profile.esgs)

  application_profile_dn = aci_application_profile.all_services_app_profile.id
  name                   = local.model.all_services_app_profile.esgs[count.index].name

  relation_fv_rs_scope   = data.aci_vrf.user_vrf.id

  dynamic "relation_fv_rs_prov" {
    for_each = local.model.all_services_app_profile.esgs[count.index].relation_fv_rs_prov
    content {
      target_dn = relation_fv_rs_prov.value
    }
  }

  dynamic "relation_fv_rs_cons" {
    for_each = local.model.all_services_app_profile.esgs[count.index].relation_fv_rs_cons
    content {
      target_dn = relation_fv_rs_cons.value
    }
  }
}

resource "aci_endpoint_security_group_tag_selector" "all_services_tag_selector" {
  count = length(local.model.all_services_app_profile.esgs)

  endpoint_security_group_dn = aci_endpoint_security_group.esg[count.index].id
  match_key                  = local.model.all_services_app_profile.esgs[count.index].key
  match_value                = local.model.all_services_app_profile.esgs[count.index].value
  value_operator             = "equals"
}

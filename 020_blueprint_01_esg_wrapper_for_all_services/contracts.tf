###############################
# Contracts
###############################

########################################
## Permit to frontend service (80, 8080) 
########################################
resource "aci_contract" "permit_to_online_boutique_all_services" {
    tenant_dn   =  data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = local.managed.contracts.permit_to_online_boutique_all_services.name
    scope       = local.managed.contracts.permit_to_online_boutique_all_services.scope
}
resource "aci_contract_subject" "permit_to_online_boutique_all_services_subject" {
    contract_dn   = aci_contract.permit_to_online_boutique_all_services.id
    description   = "Automated by Terraform"
    name          = "tcp"
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_subject_filter_80" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_subject.id
  filter_dn  = aci_filter.tcp_src_any_dst_80_filter.id
}

##################################################################
## Export contract to shared_services tenant
##################################################################
resource "aci_imported_contract" "exported_contract_to_shared_services" {
  tenant_dn   = data.aci_tenant.shared_services_tenant.id
  name        = local.managed.contracts.permit_to_online_boutique_all_services.exported_contract_name
  description = "Automated by Terraform"
  relation_vz_rs_if = aci_contract.permit_to_online_boutique_all_services.id
}

## Add exported contract to l3Out extEPG
resource "aci_rest" "fvRsConsIf" {
  path         = "/api/mo/uni/tn-${local.unmanaged.tenants.shared_services_tenant.name}/out-${local.unmanaged.tenants.shared_services_tenant.l3Out.name}/instP-${local.unmanaged.tenants.shared_services_tenant.l3Out.externalEPG.name}.json"
  class_name = "fvRsConsIf"
  content = {
    tnVzCPIfName  = aci_imported_contract.exported_contract_to_shared_services.name
  }
}



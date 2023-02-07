###############################
# Contracts
###############################

###############################
## permit-any
###############################
resource "aci_contract" "permit_any_contract" {
    tenant_dn   =  data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "permit-any"
    scope       = "context"
}
resource "aci_contract_subject" "permit_any_contract_subject" {
    contract_dn   = aci_contract.permit_any_contract.id
    description   = "Automated by Terraform"
    name          = "permit-any"
}
resource "aci_contract_subject_filter" "permit_any_contract_subject_filter" {
  contract_subject_dn  = aci_contract_subject.permit_any_contract_subject.id
  filter_dn  = aci_filter.permit_any_filter.id
}
resource "aci_contract_subject" "permit_any_contract_subject_icmp" {
    contract_dn   = aci_contract.permit_any_contract.id
    description   = "Automated by Terraform"
    name          = "icmp"
}
resource "aci_contract_subject_filter" "permit_any_contract_subject_filter_icmp" {
  contract_subject_dn  = aci_contract_subject.permit_any_contract_subject_icmp.id
  filter_dn  = aci_filter.permit_icmp_filter.id
}

########################################
## Permit to frontend service (80, 8080) 
########################################
resource "aci_contract" "permit_to_online_boutique_all_services" {
    tenant_dn   =  data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = local.model.contracts[0].name
    scope       = local.model.contracts[0].scope
}
resource "aci_contract_subject" "permit_to_online_boutique_all_services_subject" {
    contract_dn   = aci_contract.permit_to_online_boutique_all_services.id
    description   = "Automated by Terraform"
    name          = "tcp"
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_subject_filter_80" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_subject.id
  filter_dn  = aci_filter.permit_any_filter.id
}
# resource "aci_contract_subject" "permit_to_online_boutique_all_services_subject_icmp" {
#     contract_dn   = aci_contract.permit_to_online_boutique_all_services.id
#     description   = "Automated by Terraform"
#     name          = "icmp"
# }
# resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_subject_filter_icmp" {
#   contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_subject_icmp.id
#   filter_dn  = aci_filter.permit_icmp_filter.id
# }

##################################################################
## Export contract to shared_services tenant
##################################################################
resource "aci_imported_contract" "exported_contract_to_shared_services" {
  tenant_dn   = data.aci_tenant.shared_services_tenant.id
  name        = local.model.contracts[0].exported_contract_name
  description = "Automated by Terraform"
  relation_vz_rs_if = aci_contract.permit_to_online_boutique_all_services.id
}

## Add exported contract to l3Out extEPG
resource "aci_rest" "fvRsConsIf" {
  path         = "/api/mo/uni/tn-shared-services/out-shared-services.vrf-01-ospf-area-0.0.0.1/instP-lab-desktops-subnets.json"
  class_name = "fvRsConsIf"
  content = {
    tnVzCPIfName  = aci_imported_contract.exported_contract_to_shared_services.name
  }
}

##################################################################
## Export contract to rwhitear tenant
##################################################################
resource "aci_imported_contract" "exported_contract_to_tn-rwhitear" {
  tenant_dn   = data.aci_tenant.tenant_tn-rwhitear.id
  name        = aci_contract.permit_to_online_boutique_all_services.name
  description = "Automated by Terraform"
  relation_vz_rs_if = aci_contract.permit_to_online_boutique_all_services.id
}
#####################################################################
## Add contract interface to ESG epg-matched-security-group->group-01 
#####################################################################
resource "aci_rest" "add_contract_interface_to_esg_group-01" {
  path         = "/api/node/mo/uni/tn-rwhitear/ap-epg-matched-security-group/esg-group-01.json"
  class_name = "fvRsConsIf"
  content = {
    tnVzCPIfName = "permit-to-online-boutique-all-services"
  }

  depends_on = [
    aci_imported_contract.exported_contract_to_tn-rwhitear
  ]
}
# resource "aci_rest_managed" "add_contract_interface_to_esg_group-01" {
#   dn         = "uni/tn-rwhitear/ap-epg-matched-security-group/esg-group-01"
#   class_name = "fvRsConsIf"
#   content = {
#     tnVzCPIfName = "permit-to-online-boutique-all-services"
#   }

#   depends_on = [
#     aci_imported_contract.exported_contract_to_tn-rwhitear
#   ]
# }

# ##################################################################
# ## Retrieve tn-shared-services permit-to-core-services contract dn 
# ##################################################################
# data "aci_contract" "tn_shared_services_permit_to_core_services" {
#   tenant_dn  = data.aci_tenant.shared_services_tenant.id
#   name       = "permit-to-core-services"
# }

# ##########################################################
# ## Import shared-services_permit-to-core-services contract 
# ##########################################################
# resource "aci_imported_contract" "tn_shared_services_permit_to_core_services" {
#   tenant_dn   = data.aci_tenant.user_tenant.id
#   name        = "permit-to-core-services"
#   description = "Automated by Terraform"
#   relation_vz_rs_if = data.aci_contract.tn_shared_services_permit_to_core_services.id
# }

# ##########################################################
# ## Add contract interface to vzAny 
# ##########################################################
# resource "aci_rest_managed" "add_permit_to_core_services_cci_to_vzany" {
#   dn         = "uni/tn-${data.aci_tenant.user_tenant.name}/ctx-${data.aci_vrf.user_vrf.name}/any/rsanyToConsIf-${aci_imported_contract.tn_shared_services_permit_to_core_services.name}"
#   class_name = "vzRsAnyToConsIf"
#   content = {
#     tnVzCPIfName = aci_imported_contract.tn_shared_services_permit_to_core_services.name
#   }

#   depends_on = [
#     aci_imported_contract.tn_shared_services_permit_to_core_services
#   ]
# }

# ####################################################################
# ## Retrieve tn-shared-services permit-from-core-services contract dn 
# ####################################################################
# data "aci_contract" "tn_shared_services_permit_from_core_services" {
#   tenant_dn  = data.aci_tenant.shared_services_tenant.id
#   name       = "permit-from-core-services"
# }

# ############################################################
# ## Import shared-services_permit-from-core-services contract 
# ############################################################
# resource "aci_imported_contract" "tn_shared_services_permit_from_core_services" {
#   tenant_dn   = data.aci_tenant.user_tenant.id
#   name        = "permit-from-core-services"
#   description = "Automated by Terraform"
#   relation_vz_rs_if = data.aci_contract.tn_shared_services_permit_from_core_services.id
# }

# ##########################################################
# ## Add contract interface to vzAny 
# ##########################################################
# resource "aci_rest_managed" "add_permit_from_core_services_cci_to_vzany" {
#   dn         = "uni/tn-${data.aci_tenant.user_tenant.name}/ctx-${data.aci_vrf.user_vrf.name}/any/rsanyToConsIf-${aci_imported_contract.tn_shared_services_permit_from_core_services.name}"
#   class_name = "vzRsAnyToConsIf"
#   content = {
#     tnVzCPIfName = aci_imported_contract.tn_shared_services_permit_from_core_services.name
#   }

#   depends_on = [
#     aci_imported_contract.tn_shared_services_permit_from_core_services
#   ]
# }


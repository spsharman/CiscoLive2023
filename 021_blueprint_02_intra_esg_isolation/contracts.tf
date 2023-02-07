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

#########################################
## Permit to online-boutique-all-services  
#########################################
resource "aci_contract" "permit_to_online_boutique_all_services" {
    tenant_dn   =  data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "permit-to-online-boutique-all-services"
    scope       = "global"
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
resource "aci_contract_subject" "permit_to_online_boutique_all_services_subject_icmp" {
    contract_dn   = aci_contract.permit_to_online_boutique_all_services.id
    description   = "Automated by Terraform"
    name          = "icmp"
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_subject_filter_icmp" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_subject_icmp.id
  filter_dn  = aci_filter.permit_icmp_filter.id
}

##################################################
## Permit to online-boutique-all-services-isolated  
##################################################
resource "aci_contract" "permit_to_online_boutique_all_services_isolated" {
    tenant_dn   =  data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "permit-to-online-boutique-all-services-isolated"
    scope       = "context"
}
resource "aci_contract_subject" "permit_to_online_boutique_all_services_isolated_subject_icmp" {
    contract_dn   = aci_contract.permit_to_online_boutique_all_services_isolated.id
    description   = "Automated by Terraform"
    name          = "icmp"
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_icmp" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_icmp.id
  filter_dn  = aci_filter.permit_icmp_filter.id
}
resource "aci_contract_subject" "permit_to_online_boutique_all_services_isolated_subject_all_services" {
    contract_dn   = aci_contract.permit_to_online_boutique_all_services_isolated.id
    description   = "Automated by Terraform"
    name          = "redirect"
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_http" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_80_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_productcatalog" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_3550_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_email" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_5000_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_checkout" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_5050_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_redis" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_6379_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_currency" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_7000_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_cart" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_7070_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_recommendation" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_8080_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_ad" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_9555_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_all_services_isolated_subject_filter_all_services_shipping" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id
  filter_dn  = aci_filter.tcp_src_any_dst_50051_filter.id
}

##################################################################
## Export contract to shared_services tenant
##################################################################
resource "aci_imported_contract" "exported_contract_to_shared_services" {
  tenant_dn   = data.aci_tenant.shared_services_tenant.id
  name        = aci_contract.permit_to_online_boutique_all_services.name
  description = "Automated by Terraform"
  relation_vz_rs_if = aci_contract.permit_to_online_boutique_all_services.id
}

## Add exported contract to l3Out extEPG
resource "aci_rest" "fvRsConsIf" {
  path         = "/api/mo/uni/tn-shared-services/out-shared-services.vrf-01-ospf-area-0.0.0.1/instP-all-external-subnets.json"
  class_name = "fvRsConsIf"
  content = {
    tnVzCPIfName  = aci_contract.permit_to_online_boutique_all_services.name
  }
}

##################################################################
## Retrieve tn-shared-services permit-to-core-services contract dn 
##################################################################
data "aci_contract" "tn_shared_services_permit_to_core_services" {
  tenant_dn  = data.aci_tenant.shared_services_tenant.id
  name       = "permit-to-core-services"
}

##########################################################
## Import shared-services_permit-to-core-services contract 
##########################################################
resource "aci_imported_contract" "tn_shared_services_permit_to_core_services" {
  tenant_dn   = data.aci_tenant.user_tenant.id
  name        = "tn-shared-services_permit-to-core-services"
  description = "Automated by Terraform"
  relation_vz_rs_if = data.aci_contract.tn_shared_services_permit_to_core_services.id
}

##########################################################
## Add contract interface to vzAny 
##########################################################
resource "aci_rest_managed" "add_permit_to_core_services_cci_to_vzany" {
  dn         = "uni/tn-${data.aci_tenant.user_tenant.name}/ctx-${data.aci_vrf.user_vrf.name}/any/rsanyToConsIf-${aci_imported_contract.tn_shared_services_permit_to_core_services.name}"
  class_name = "vzRsAnyToConsIf"
  content = {
    tnVzCPIfName = aci_imported_contract.tn_shared_services_permit_to_core_services.name
  }

  depends_on = [
    aci_imported_contract.tn_shared_services_permit_to_core_services
  ]
}

####################################################################
## Retrieve tn-shared-services permit-from-core-services contract dn 
####################################################################
data "aci_contract" "tn_shared_services_permit_from_core_services" {
  tenant_dn  = data.aci_tenant.shared_services_tenant.id
  name       = "permit-from-core-services"
}

############################################################
## Import shared-services_permit-from-core-services contract 
############################################################
resource "aci_imported_contract" "tn_shared_services_permit_from_core_services" {
  tenant_dn   = data.aci_tenant.user_tenant.id
  name        = "tn-shared-services_permit-from-core-services"
  description = "Automated by Terraform"
  relation_vz_rs_if = data.aci_contract.tn_shared_services_permit_from_core_services.id
}

##########################################################
## Add contract interface to vzAny 
##########################################################
resource "aci_rest_managed" "add_permit_from_core_services_cci_to_vzany" {
  dn         = "uni/tn-${data.aci_tenant.user_tenant.name}/ctx-${data.aci_vrf.user_vrf.name}/any/rsanyToConsIf-${aci_imported_contract.tn_shared_services_permit_from_core_services.name}"
  class_name = "vzRsAnyToConsIf"
  content = {
    tnVzCPIfName = aci_imported_contract.tn_shared_services_permit_from_core_services.name
  }

  depends_on = [
    aci_imported_contract.tn_shared_services_permit_from_core_services
  ]
}


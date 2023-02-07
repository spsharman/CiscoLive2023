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

##################################
## Permit to redis database (6379)
##################################
resource "aci_contract" "permit_to_online_boutique_redis_database_contract" {
    tenant_dn   =  data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "permit-to-online-boutique-redis-database"
    scope       = "context"
}
resource "aci_contract_subject" "permit_to_online_boutique_redis_database_contract_subject" {
    contract_dn   = aci_contract.permit_to_online_boutique_redis_database_contract.id
    description   = "Automated by Terraform"
    name          = "tcp"
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_redis_database_contract_subject_filter" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_redis_database_contract_subject.id
  filter_dn  = aci_filter.tcp_src_any_dst_6379_filter.id
}
resource "aci_contract_subject" "permit_to_online_boutique_redis_database_contract_subject_icmp" {
    contract_dn   = aci_contract.permit_to_online_boutique_redis_database_contract.id
    description   = "Automated by Terraform"
    name          = "icmp"
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_redis_database_contract_subject_filter_icmp" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_redis_database_contract_subject_icmp.id
  filter_dn  = aci_filter.permit_icmp_filter.id
}

########################################
## Permit to frontend service (80, 8080) 
########################################
resource "aci_contract" "permit_to_online_boutique_frontend_service_contract" {
    tenant_dn   =  data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "permit-to-online-boutique-frontend-service"
    scope       = "global"
}
resource "aci_contract_subject" "permit_to_online_boutique_frontend_service_contract_subject" {
    contract_dn   = aci_contract.permit_to_online_boutique_frontend_service_contract.id
    description   = "Automated by Terraform"
    name          = "redirect"
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_frontend_service_contract_subject_filter_80" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_frontend_service_contract_subject.id
  filter_dn  = aci_filter.tcp_src_any_dst_80_filter.id
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_frontend_service_contract_subject_filter_8080" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_frontend_service_contract_subject.id
  filter_dn  = aci_filter.tcp_src_any_dst_8080_filter.id
}
resource "aci_contract_subject" "permit_to_online_boutique_frontend_service_contract_subject_icmp" {
    contract_dn   = aci_contract.permit_to_online_boutique_frontend_service_contract.id
    description   = "Automated by Terraform"
    name          = "icmp"
}
resource "aci_contract_subject_filter" "permit_to_online_boutique_frontend_service_contract_subject_filter_icmp" {
  contract_subject_dn  = aci_contract_subject.permit_to_online_boutique_frontend_service_contract_subject_icmp.id
  filter_dn  = aci_filter.permit_icmp_filter.id
}

##################################################################
## Export contract to shared_services tenant
##################################################################
resource "aci_imported_contract" "exported_contract_to_shared_services" {
  tenant_dn   = data.aci_tenant.shared_services_tenant.id
  name        = aci_contract.permit_to_online_boutique_frontend_service_contract.name
  description = "Automated by Terraform"
  relation_vz_rs_if = aci_contract.permit_to_online_boutique_frontend_service_contract.id
}

## Add exported contract to l3Out extEPG
resource "aci_rest" "fvRsConsIf" {
  path         = "/api/mo/uni/tn-shared-services/out-shared-services.vrf-01-ospf-area-0.0.0.1/instP-all-external-subnets.json"
  class_name = "fvRsConsIf"
  content = {
    tnVzCPIfName  = aci_contract.permit_to_online_boutique_frontend_service_contract.name
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


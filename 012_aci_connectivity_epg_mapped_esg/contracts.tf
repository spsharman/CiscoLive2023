#################################################################
## Retrieve tn-shared-services permit-to-core-services contract dn 
##################################################################
data "aci_contract" "tn_shared_services_permit_to_core_services" {
  tenant_dn  = data.aci_tenant.shared_services_tenant.id
  name       = local.model.shared_services_tenant_contracts[0].name
}

##########################################################
## Import shared-services_permit-to-core-services contract 
##########################################################
resource "aci_imported_contract" "tn_shared_services_permit_to_core_services" {
  tenant_dn   = data.aci_tenant.user_tenant.id
  name        = "permit-to-core-services"
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
  name       = local.model.shared_services_tenant_contracts[1].name
}

############################################################
## Import shared-services_permit-from-core-services contract 
############################################################
resource "aci_imported_contract" "tn_shared_services_permit_from_core_services" {
  tenant_dn   = data.aci_tenant.user_tenant.id
  name        = "permit-from-core-services"
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

####################################################################
## Retrieve tn-shared-services permit-from-lab-desktops contract dn 
####################################################################
data "aci_contract" "tn_shared_services_permit_from_lab_desktops" {
  tenant_dn  = data.aci_tenant.shared_services_tenant.id
  name       = local.model.shared_services_tenant_contracts[1].name
}

############################################################
## Import shared-services_permit-from-lab-desktops contract 
############################################################
resource "aci_imported_contract" "tn_shared_services_permit_from_lab_desktops" {
  tenant_dn   = data.aci_tenant.user_tenant.id
  name        = "permit-from-lab-desktops"
  description = "Automated by Terraform"
  relation_vz_rs_if = data.aci_contract.tn_shared_services_permit_from_lab_desktops.id
}

##########################################################
## Add contract interface to vzAny 
##########################################################
resource "aci_rest_managed" "add_permit_from_lab_desktops_cci_to_vzany" {
  dn         = "uni/tn-${data.aci_tenant.user_tenant.name}/ctx-${data.aci_vrf.user_vrf.name}/any/rsanyToConsIf-${aci_imported_contract.tn_shared_services_permit_from_lab_desktops.name}"
  class_name = "vzRsAnyToConsIf"
  content = {
    tnVzCPIfName = aci_imported_contract.tn_shared_services_permit_from_lab_desktops.name
  }

  depends_on = [
    aci_imported_contract.tn_shared_services_permit_from_lab_desktops
  ]
}
#########################################################
# Shared Services tenant and VRF data
#########################################################
data "aci_tenant" "shared_services_tenant" {
  name  = local.model.shared_services_tenant.name
}

data "aci_vrf" "shared_services_vrf" {
  tenant_dn  = data.aci_tenant.shared_services_tenant.id
  name       = local.model.shared_services_tenant.vrf
}

data "aci_l3_outside" "shared_services_l3_out" {
  tenant_dn  = data.aci_tenant.shared_services_tenant.id 
  name       = local.model.shared_services_tenant.l3out.name
}


##################################
# User tenant networking
##################################
resource "aci_tenant" "aci_tenant" {
  name        = local.model.tenant.name
  description = local.model.tenant.description
}

resource "aci_vrf" "aci_vrf" {
  tenant_dn   = aci_tenant.aci_tenant.id
  name        = local.model.tenant.vrf
  description = "Automated by Terraform"
}

module "aci_bd_subnet" {
  source = "./modules/bd_subnet"

  count = length(local.model.tenant.bridge_domain)

  tenant_id = aci_tenant.aci_tenant.id
  vrf_id    = aci_vrf.aci_vrf.id

  bd = local.model.tenant.bridge_domain[count.index]

}

##################################
# App profile and EPGs
##################################
resource "aci_application_profile" "aci_ap" {
  tenant_dn   = aci_tenant.aci_tenant.id
  name        = local.model.tenant.app_profile.name
  description = "Automated by Terraform"
}

module "create_epg" {
  source = "./modules/epg"

  count = length(local.model.tenant.app_profile.epg)

  epg_name = local.model.tenant.app_profile.epg[count.index].name
  bd_name = local.model.tenant.app_profile.epg[count.index].bd_name
  vrf_id = aci_vrf.aci_vrf.id
  tenant_id = aci_tenant.aci_tenant.id
  app_profile_id = aci_application_profile.aci_ap.id

  depends_on = [
    module.aci_bd_subnet
  ]
}

##################################
# Contracts and Filters
##################################

## Permit Any ##
resource "aci_filter" "permit_any_filter" {
    tenant_dn   = aci_tenant.aci_tenant.id
    description = "Automated by Terraform"
    name        = local.model.tenant.contracts[0].filter.name
}

resource "aci_filter_entry" "permit_any_filter_entry" {
    filter_dn     = aci_filter.permit_any_filter.id
    description   = "Automated by Terraform"
    name          = local.model.tenant.contracts[0].filter.filter_entry.name
    d_from_port   = local.model.tenant.contracts[0].filter.filter_entry.d_from_port
    d_to_port     = local.model.tenant.contracts[0].filter.filter_entry.d_to_port
}

resource "aci_contract" "permit_any_contract" {
    tenant_dn   =  aci_tenant.aci_tenant.id
    description = "Automated by Terraform"
    name        = local.model.tenant.contracts[0].name
    scope       = local.model.tenant.contracts[0].scope
}

resource "aci_contract_subject" "permit_any_contract_subject" {
    contract_dn   = aci_contract.permit_any_contract.id
    description   = "Automated by Terraform"
    name          = local.model.tenant.contracts[0].subject.name
}

resource "aci_contract_subject_filter" "permit_any_contract_subject_filter" {
  contract_subject_dn  = aci_contract_subject.permit_any_contract_subject.id
  filter_dn  = aci_filter.permit_any_filter.id
}


## permit-to-tn-ciscolive-07 ##
resource "aci_contract" "permit-to-tn-ciscolive-07_contract" {
    tenant_dn   =  aci_tenant.aci_tenant.id
    description = "Automated by Terraform"
    name        = local.model.tenant.contracts[1].name
    scope       = local.model.tenant.contracts[1].scope
}

resource "aci_contract_subject" "permit-to-tn-ciscolive-07_contract_subject" {
    contract_dn   = aci_contract.permit-to-tn-ciscolive-07_contract.id
    description   = "Automated by Terraform"
    name          = local.model.tenant.contracts[1].subject.name
}

resource "aci_contract_subject_filter" "permit-to-tn-ciscolive-07_contract_subject_filter" {
  contract_subject_dn  = aci_contract_subject.permit-to-tn-ciscolive-07_contract_subject.id
  filter_dn  = aci_filter.permit_any_filter.id
}

## Export contract to shared_services tenant
resource "aci_imported_contract" "exported_contract" {
  tenant_dn   = data.aci_tenant.shared_services_tenant.id
  name        = local.model.tenant.contracts[1].name
  description = "Automated by Terraform"
  relation_vz_rs_if = aci_contract.permit-to-tn-ciscolive-07_contract.id
}


# There is an ACI bug where the UI is required to create the Dn in the backend rather than vice versa. 
# This resource performs the same action. Without it, aci_rest_managed.leakInternalSubnet will fail due
# to the Dn not existing. 
resource "aci_rest_managed" "leakRoutes" {
  dn         = "${aci_tenant.aci_tenant.id}/ctx-${aci_vrf.aci_vrf.name}/leakroutes"
  class_name = "leakRoutes"

  depends_on = [
    aci_tenant.aci_tenant,
    aci_vrf.aci_vrf,
    data.aci_tenant.shared_services_tenant,
    data.aci_vrf.shared_services_vrf,
    module.aci_bd_subnet,
    module.create_epg
  ]
}

resource "aci_rest_managed" "leakInternalSubnet" {
  count = length(local.model.tenant.bridge_domain)

  dn         = "${aci_tenant.aci_tenant.id}/ctx-${aci_vrf.aci_vrf.name}/leakroutes/leakintsubnet-[${local.model.tenant.bridge_domain[count.index].vrf_leak_routes_epg_bd_subnet}]"
  class_name = "leakInternalSubnet"
  content = {
    ip  = local.model.tenant.bridge_domain[count.index].vrf_leak_routes_epg_bd_subnet
    scope = "public"
  }

  child {
    rn = "to-[${data.aci_tenant.shared_services_tenant.name}]-[${data.aci_vrf.shared_services_vrf.name}]"
    class_name = "leakTo"
    content = {
      tenantName = data.aci_tenant.shared_services_tenant.name
      ctxName = data.aci_vrf.shared_services_vrf.name
    }
  }

  depends_on = [
    aci_rest_managed.leakRoutes
  ]
}

resource "aci_rest_managed" "leakInternalSubnet_tn-rwhitear" {
  count = length(local.model.tenant.bridge_domain)

  dn         = "${aci_tenant.aci_tenant.id}/ctx-${aci_vrf.aci_vrf.name}/leakroutes/leakintsubnet-[${local.model.tenant.bridge_domain[count.index].vrf_leak_routes_epg_bd_subnet}]"
  class_name = "leakInternalSubnet"
  content = {
    ip  = local.model.tenant.bridge_domain[count.index].vrf_leak_routes_epg_bd_subnet
    scope = "public"
  }

  child {
    rn = "to-[rwhitear]-[vrf-01]"
    class_name = "leakTo"
    content = {
      tenantName = "rwhitear"
      ctxName = "vrf-01"
      scope = "public"
    }
  }

  depends_on = [
    aci_rest_managed.leakRoutes
  ]
}

resource "aci_rest_managed" "leakTo" {
  dn         = "${data.aci_tenant.shared_services_tenant.id}/ctx-${data.aci_vrf.shared_services_vrf.name}/leakroutes/leakextsubnet-[${local.model.shared_services_tenant.leakextsubnet}]/to-[${aci_tenant.aci_tenant.name}]-[${aci_vrf.aci_vrf.name}]"
  class_name = "leakTo"

  content = {
    tenantName  = aci_tenant.aci_tenant.name
    ctxName = aci_vrf.aci_vrf.name
  }

  depends_on = [
    aci_rest_managed.leakInternalSubnet
  ]
}

resource "aci_rest" "fvRsConsIf" {
  path         = "/api/mo/uni/tn-${data.aci_tenant.shared_services_tenant.name  }/out-${data.aci_l3_outside.shared_services_l3_out.name}/instP-${local.model.shared_services_tenant.l3out.external_epg_name}.json"
  class_name = "fvRsConsIf"
  content = {
    tnVzCPIfName  = local.model.tenant.contracts[1].name
  }

  depends_on = [
    aci_imported_contract.exported_contract
  ]
}

data "aci_tenant" "user_tenant" {
  name = local.model.tenant_name
}

data "aci_tenant" "shared_services_tenant" {
  name = local.model.shared_services_tenant_name
}

data "aci_vrf" "user_vrf" {
  tenant_dn = data.aci_tenant.user_tenant.id
  name      = local.model.vrf_name
}

data "aci_bridge_domain" "bd_10_0_75_0_24" {
  tenant_dn  = data.aci_tenant.user_tenant.id
  name       = "10.0.75.0_24"
}

# data "aci_contract" "permit-to-tn-ciscolive-07" {
#   tenant_dn  = data.aci_tenant.user_tenant.id
#   name       = "permit-to-tn-ciscolive-07"
# }
data "aci_bridge_domain" "aci_bd" {
  tenant_dn  = var.tenant_id
  name       = var.bd_name
}

resource "aci_application_epg" "aci_epg" {
  # count = length(local.model.tenant.app_profile.epg)

  name                   = var.epg_name
  description            = "Automated by terraform"

  application_profile_dn = var.app_profile_id
  relation_fv_rs_bd       = data.aci_bridge_domain.aci_bd.id
}

data "aci_vmm_domain" "dev_vmmdom" {
  provider_profile_dn  = "uni/vmmp-VMware"
  name                 = "ucsc-c220m5-vds-01"
}

resource "aci_epg_to_domain" "vmm_domain" {
  application_epg_dn    = aci_application_epg.aci_epg.id
  tdn                   = data.aci_vmm_domain.dev_vmmdom.id
  allow_micro_seg       = "true"
  instr_imedcy          = "immediate"
}

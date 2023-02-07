resource "aci_bridge_domain" "aci_bd" {
  tenant_dn          = var.tenant_id
  description        = "Automated by terraform"
  name               = var.bd.name
  relation_fv_rs_ctx = var.vrf_id
}

resource "aci_subnet" "aci_bd_subnet" {
  parent_dn   = aci_bridge_domain.aci_bd.id
  description = "Automated by terraform"
  ip          = var.bd.subnet

  scope = ["shared","public"]
}

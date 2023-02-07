###############################
# Filters
###############################

## Permit ICMP ##
resource "aci_filter" "permit_icmp_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "permit-icmp"
}
resource "aci_filter_entry" "permit_icmp_filter_entry" {
    filter_dn     = aci_filter.permit_icmp_filter.id
    description   = "Automated by Terraform"
    name          = "icmp"
    ether_t       = "ip"
    prot          = "icmp"
}

## Permit Any ##
resource "aci_filter" "permit_any_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "permit-any"
}
resource "aci_filter_entry" "permit_any_filter_entry" {
    filter_dn     = aci_filter.permit_any_filter.id
    description   = "Automated by Terraform"
    name          = "unspecified"
    d_from_port   = "unspecified"
    d_to_port     = "unspecified"
}


## Permit to 80 (http) ##
resource "aci_filter" "tcp_src_any_dst_80_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = local.managed.filters.tcp_src_any_dst_80_filter.name
}
resource "aci_filter_entry" "tcp_src_any_dst_80_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_80_filter.id
    description   = "Automated by Terraform"
    name          = local.managed.filter_entries.tcp_src_any_dst_80_filter_entry.name
    ether_t       = local.managed.filter_entries.tcp_src_any_dst_80_filter_entry.ether_t
    prot          = local.managed.filter_entries.tcp_src_any_dst_80_filter_entry.prot
    d_from_port   = local.managed.filter_entries.tcp_src_any_dst_80_filter_entry.d_from_port
    d_to_port     = local.managed.filter_entries.tcp_src_any_dst_80_filter_entry.d_to_port
}
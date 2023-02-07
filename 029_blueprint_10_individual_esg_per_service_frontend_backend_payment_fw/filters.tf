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

## Permit to 22 (ssh) ##
resource "aci_filter" "tcp_src_any_dst_22_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-22"
}
resource "aci_filter_entry" "tcp_src_any_dst_22_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_22_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-22"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "22"
    d_to_port     = "22"
}

## Permit to 80 (http) ##
resource "aci_filter" "tcp_src_any_dst_80_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-80"
}
resource "aci_filter_entry" "tcp_src_any_dst_80_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_80_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-80"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "80"
    d_to_port     = "80"
}

## Permit to 443 (https) ##
resource "aci_filter" "tcp_src_any_dst_443_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-443"
}
resource "aci_filter_entry" "tcp_src_any_dst_443_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_443_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-443"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "443"
    d_to_port     = "443"
}

## Permit to 3550 (productcatalog-service) ##
resource "aci_filter" "tcp_src_any_dst_3550_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-3550"
}
resource "aci_filter_entry" "tcp_src_any_dst_3550_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_3550_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-3550"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "3550"
    d_to_port     = "3550"
}

## Permit to 5000 (email-service) ##
resource "aci_filter" "tcp_src_any_dst_5000_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-5000"
}
resource "aci_filter_entry" "tcp_src_any_dst_5000_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_5000_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-5000"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "5000"
    d_to_port     = "5000"
}

## Permit to 5050 (checkout-service) ##
resource "aci_filter" "tcp_src_any_dst_5050_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-5050"
}
resource "aci_filter_entry" "tcp_src_any_dst_5050_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_5050_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-5050"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "5050"
    d_to_port     = "5050"
}

## Permit to 6379 (redis) ##
resource "aci_filter" "tcp_src_any_dst_6379_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-6379"
}
resource "aci_filter_entry" "tcp_src_any_dst_6379_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_6379_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-6379"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "6379"
    d_to_port     = "6379"
}

## Permit to 7000 (currency-service) ##
resource "aci_filter" "tcp_src_any_dst_7000_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-7000"
}
resource "aci_filter_entry" "tcp_src_any_dst_7000_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_7000_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-7000"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "7000"
    d_to_port     = "7000"
}

## Permit to 7070 (cart-service) ##
resource "aci_filter" "tcp_src_any_dst_7070_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-7070"
}
resource "aci_filter_entry" "tcp_src_any_dst_7070_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_7070_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-7070"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "7070"
    d_to_port     = "7070"
}

## Permit to 8080 (recommendation-service) ##
resource "aci_filter" "tcp_src_any_dst_8080_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-8080"
}
resource "aci_filter_entry" "tcp_src_any_dst_8080_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_8080_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-8080"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "8080"
    d_to_port     = "8080"
}

## Permit to 9555 (ad-service) ##
resource "aci_filter" "tcp_src_any_dst_9555_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-9555"
}
resource "aci_filter_entry" "tcp_src_any_dst_9555_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_9555_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-9555"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "9555"
    d_to_port     = "9555"
}

## Permit to 50051 (shipping-service) ##
resource "aci_filter" "tcp_src_any_dst_50051_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "tcp-src-any-dst-50051"
}
resource "aci_filter_entry" "tcp_src_any_dst_50051_filter_entry" {
    filter_dn     = aci_filter.tcp_src_any_dst_50051_filter.id
    description   = "Automated by Terraform"
    name          = "tcp-src-any-dst-50051"
    ether_t       = "ip"
    prot          = "tcp"
    d_from_port   = "50051"
    d_to_port     = "50051"
}

## Service Graph Redirect to FTDv ##
resource "aci_filter" "permit_any_to_ftdv_02_gig_0_3_filter" {
    tenant_dn   = data.aci_tenant.user_tenant.id
    description = "Automated by Terraform"
    name        = "permit-any-to-ftdv-02-gig-0-3"
}
resource "aci_filter_entry" "permit_any_to_ftdv_02_gig_0_3_filter_entry" {
    filter_dn     = aci_filter.permit_any_to_ftdv_02_gig_0_3_filter.id
    description   = "Automated by Terraform"
    name          = "unspecified"
    d_from_port   = "unspecified"
    d_to_port     = "unspecified"
}
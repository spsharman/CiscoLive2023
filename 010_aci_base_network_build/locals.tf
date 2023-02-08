locals {
  model = {
    tenant = {
      name = var.TENANT_NAME
      description = "Routable IP range 192.168.150-156.x"
      vrf  = "vrf-01"
      bridge_domain = [
        {
          name   = "192.168.150.0_24"
          subnet = "192.168.150.1/24"
          vrf_leak_routes_epg_bd_subnet = "192.168.150.0/24"
          dhcp_label_name = "dhcp.uktme.cisco.com"
        },
        {
          name   = "192.168.151.0_24"
          subnet = "192.168.151.1/24"
          vrf_leak_routes_epg_bd_subnet = "192.168.151.0/24"
          dhcp_label_name = "dhcp.uktme.cisco.com"
        },
        {
          name   = "192.168.152.0_24"
          subnet = "192.168.152.1/24"
          vrf_leak_routes_epg_bd_subnet = "192.168.152.0/24"
          dhcp_label_name = "dhcp.uktme.cisco.com"
        },
        {
          name   = "192.168.153.0_24"
          subnet = "192.168.153.1/24"
          vrf_leak_routes_epg_bd_subnet = "192.168.153.0/24"
          dhcp_label_name = "dhcp.uktme.cisco.com"
        },
        {
          name   = "192.168.154.0_24"
          subnet = "192.168.154.1/24"
          vrf_leak_routes_epg_bd_subnet = "192.168.154.0/24"
          dhcp_label_name = "dhcp.uktme.cisco.com"
        },
        {
          name   = "192.168.155.0_24"
          subnet = "192.168.155.1/24"
          vrf_leak_routes_epg_bd_subnet = "192.168.155.0/24"
          dhcp_label_name = "dhcp.uktme.cisco.com"
        },
        {
          name   = "192.168.156.0_24"
          subnet = "192.168.156.1/24"
          vrf_leak_routes_epg_bd_subnet = "192.168.156.0/24"
          dhcp_label_name = "dhcp.uktme.cisco.com"
        }
      ]
      app_profile = {
        name = "network-segments"
        epg = [
          {
            name = "192.168.150.0_24"
            bd_name = "192.168.150.0_24"
            vmm_domain_name = "ucsc-c220m5-vds-01"
          },
          {
            name = "192.168.151.0_24"
            bd_name = "192.168.151.0_24"
            vmm_domain_name = "ucsc-c220m5-vds-01"
          },
          {
            name = "192.168.152.0_24"
            bd_name = "192.168.152.0_24"
            vmm_domain_name = "ucsc-c220m5-vds-01"
          },
          {
            name = "192.168.153.0_24"
            bd_name = "192.168.153.0_24"
            vmm_domain_name = "ucsc-c220m5-vds-01"
          },
          {
            name = "192.168.154.0_24"
            bd_name = "192.168.154.0_24"
            vmm_domain_name = "ucsc-c220m5-vds-01"
          },
          {
            name = "192.168.155.0_24"
            bd_name = "192.168.155.0_24"
            vmm_domain_name = "ucsc-c220m5-vds-01"
          },
          {
            name = "192.168.156.0_24"
            bd_name = "192.168.156.0_24"
            vmm_domain_name = "ucsc-c220m5-vds-01"
          }
        ]
      }
      contracts = [
        {
          name = "permit-any"
          scope = "context"
          subjects = {
            permit_any = {
              name = "permit-any"
            }
            permit_icmp = {
              name = "permit-icmp"
            }
          }
          filters = {
            permit_any = {
              name = "permit-any"
              filter_entry = {
                name        = "unspecified"
                d_from_port = "unspecified"
                d_to_port   = "unspecified"
              }
            }
            permit_icmp = {
              name = "permit-icmp"
              filter_entry = {
                name        = "icmp"
                ether_t     = "ip"
                prot        = "icmp"
              }
            }
          }
        },
        {
          # name = "permit-to-tn-demo"
          name = "permit-to-tn-${var.TENANT_NAME}"
          scope = "global"
          subject = {
            name = "permit-any"
          }
          filter = {
            name = "permit-any"
            filter_entry = {
              name        = "unspecified"
              d_from_port = "unspecified"
              d_to_port   = "unspecified"
            }
          }
        }
      ]
    }
    shared_services_tenant = {
      name = "shared-services"
      vrf = "vrf-01"
      leakextsubnet = "0.0.0.0/0"
      l3out = {
        name = "shared-services.vrf-01-ospf-area-0.0.0.1"
        external_epg_name = "all-external-subnets"
      }
    }
  }
}


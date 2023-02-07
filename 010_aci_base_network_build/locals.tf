locals {
  model = {
    tenant = {
      name = "ciscolive-07"
      description = "Routable IP range 10.0.71-75.x"
      vrf  = "vrf-01"
      bridge_domain = [
        {
          name   = "10.0.71.0_24"
          subnet = "10.0.71.1/24"
          vrf_leak_routes_epg_bd_subnet = "10.0.71.0/24"
        },
        {
          name   = "10.0.72.0_24"
          subnet = "10.0.72.1/24"
          vrf_leak_routes_epg_bd_subnet = "10.0.72.0/24"
        },
        {
          name   = "10.0.73.0_24"
          subnet = "10.0.73.1/24"
          vrf_leak_routes_epg_bd_subnet = "10.0.73.0/24"
        },
        {
          name   = "10.0.74.0_24"
          subnet = "10.0.74.1/24"
          vrf_leak_routes_epg_bd_subnet = "10.0.74.0/24"
        },
        {
          name   = "10.0.75.0_24"
          subnet = "10.0.75.1/24"
          vrf_leak_routes_epg_bd_subnet = "10.0.75.0/24"
        }
      ]
      app_profile = {
        name = "network-segments"
        epg = [
          {
            name = "10.0.71.0_24"
            bd_name = "10.0.71.0_24"
          },
          {
            name = "10.0.72.0_24"
            bd_name = "10.0.72.0_24"
          },
          {
            name = "10.0.73.0_24"
            bd_name = "10.0.73.0_24"
          },
          {
            name = "10.0.74.0_24"
            bd_name = "10.0.74.0_24"
          },
          {
            name = "10.0.75.0_24"
            bd_name = "10.0.75.0_24"
          }
        ]
      }
      contracts = [
        {
          name = "permit-any"
          scope = "context"
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
        },
        {
          name = "permit-to-tn-ciscolive-07"
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


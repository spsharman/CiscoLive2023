locals {
  model = {
    data_resource = {
      tenant = {
        name = var.TENANT_NAME
        vrf = {
          name = "vrf-01"
        }
        contract = {
            name = "permit-to-tn-${var.TENANT_NAME}"
        }
      }
      shared_services_tenant = {
        name = "shared-services"
        contracts = [
          {
            name = "permit-to-core-services"
          },
          {
            name = "permit-from-core-services"
          },
          {
            name = "permit-from-lab-desktops"
          }
        ]
      }
    }
    resource = {
      app_profile = {
        name = "epg-matched-esg"
      }
      esg = {
        name = "network-segments",
        epg_selectors = [
        {
          app_profile_name = "network-segments",
          epg_name = "192.168.150.0_24"
        },
        {
          app_profile_name = "network-segments",
          epg_name = "192.168.151.0_24"
        },
        {
          app_profile_name = "network-segments",
          epg_name = "192.168.152.0_24"
        },
        {
          app_profile_name = "network-segments",
          epg_name = "192.168.153.0_24"
        },
        {
          app_profile_name = "network-segments",
          epg_name = "192.168.154.0_24"
        },
        {
          app_profile_name = "network-segments",
          epg_name = "192.168.155.0_24"
        },
        {
          app_profile_name = "network-segments",
          epg_name = "192.168.156.0_24"
        }
        ]
      }
    }
  }
}
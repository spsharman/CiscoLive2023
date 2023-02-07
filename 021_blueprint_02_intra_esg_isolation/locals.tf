locals {
  model = {
    tenant_name      = "ciscolive-07"
    vrf_name         = "vrf-01"
    shared_services_tenant_name = "shared-services"
    all_services_app_profile = {
      app_profile_name = "online-boutique"
      esg = {
        name = "all-services"
      }
      esg_tags = [
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-ad-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-cart-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-checkout-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-currency-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-email-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-frontend-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-payment-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-productcatalog-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-recommendation-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-shipping-service"
        },
        {
          key   = "Function"
          value = "${var.prefix}-online-boutique-redis-database"
        }
      ]
    }
    l4_l7 = {
      device_name = "ftdv-02-eth6-gig-0-3"
      pbr_policy = {
        name = "redirect-to-ftdv-02-gig-0-3"
        dest_type = "L3"
        hashing_algorithm = "sip-dip-prototype"
        L3_destination = {
          ftdv_ip = "10.0.75.12"
          ftdv_mac = "00:50:56:A1:08:0E"
        }
      }
      service_graph_template = {
        name = "redirect-to-ftdv-02-gig-0-3"
        function_node = {
          name = "N1"
          template_type = "FW_ROUTED"
          function_type = "GoTo"
        }
      }
    }
  }
}



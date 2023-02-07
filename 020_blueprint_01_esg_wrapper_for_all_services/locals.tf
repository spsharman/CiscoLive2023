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
    contracts = [
      {
        name = "permit-to-online-boutique-all-services"
        scope = "global"
        exported_contract_name = "permit-to-tn-ciscolive-07-online-boutique-all-services"
      }
    ]
  }
}


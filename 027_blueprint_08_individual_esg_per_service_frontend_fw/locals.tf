locals {
  model = {
    tenant_name      = "ciscolive-07"
    vrf_name         = "vrf-01"
    shared_services_tenant_name = "shared-services"
    all_services_app_profile = {
      app_profile_name = "online-boutique"
      esgs = [
        {
          name = "bp-${var.blueprint_id}-ad-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-ad-service"

          relation_fv_rs_prov = {
            ad_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-ad-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {}
        },
        {
          name = "bp-${var.blueprint_id}-cart-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-cart-service"

          relation_fv_rs_prov = {
            cart_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-cart-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {
            redis_database_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-redis-database"
          }
        },
        {
          name = "bp-${var.blueprint_id}-checkout-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-checkout-service"

          relation_fv_rs_prov = {
            checkout_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-checkout-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {
            cart_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-cart-service"
            currency_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-currency-service"
            email_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-email-service"
            payment_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-payment-service"
            productcatalog_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-product-catalogue-service"
            shipping_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-shipping-service"
          }
        },
        {
          name = "bp-${var.blueprint_id}-currency-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-currency-service"

          relation_fv_rs_prov = {
            currency_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-currency-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {}
        },
        {
          name = "bp-${var.blueprint_id}-email-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-email-service"

          relation_fv_rs_prov = {
            email_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-email-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {}
        },
        {
          name = "bp-${var.blueprint_id}-frontend-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-frontend-service"

          relation_fv_rs_prov = {
            frontend_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-frontend-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {
            ad_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-ad-service"
            cart_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-cart-service"
            checkout_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-checkout-service"
            currency_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-currency-service"
            productcatalog_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-product-catalogue-service"
            recommendation_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-recommendation-service"
            shipping_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-shipping-service"            
          }
        },
        {
          name = "bp-${var.blueprint_id}-payment-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-payment-service"

          relation_fv_rs_prov = {
            payment_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-payment-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {}
        },
        {
          name = "bp-${var.blueprint_id}-productcatalog-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-productcatalog-service"

          relation_fv_rs_prov = {
            productcatalog_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-product-catalogue-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {}
        },
        {
          name = "bp-${var.blueprint_id}-recommendation-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-recommendation-service"

          relation_fv_rs_prov = {
            recommendation_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-recommendation-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {
            productcatalog_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-product-catalogue-service"
          }
        },
        {
          name = "bp-${var.blueprint_id}-shipping-svc"
          key   = "Function"
          value = "${var.prefix}-online-boutique-shipping-service"

          relation_fv_rs_prov = {
            shipping_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-shipping-service"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {}
        }
      ]
    }
    databases_app_profile = {
      app_profile_name = "databases"
      esgs = [
        {
          name = "bp-${var.blueprint_id}-redis-db"
          key   = "Function"
          value = "${var.prefix}-online-boutique-redis-database"

          relation_fv_rs_prov = {
            redis_database_service = "uni/tn-ciscolive-07/brc-permit-to-online-boutique-redis-database"
            # permit_to_tn_ciscolive-07 = "uni/tn-ciscolive-07/brc-permit-to-tn-ciscolive-07"
          }
          relation_fv_rs_cons = {}
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


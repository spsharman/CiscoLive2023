locals {
  unmanaged = {
    tenants = {
      user_tenant = {
        name = var.TENANT_NAME
        vrf = {
          name = "vrf-01"
        }
        bridge_domains = {
          BD_192_168_150_0_24 = {
            name = "192.168.150.0_24"
          }
          BD_192_168_151_0_24 = {
            name = "192.168.151.0_24"
          }
          BD_192_168_152_0_24 = {
            name = "192.168.152.0_24"
          }
          BD_192_168_150_0_24 = {
            name = "192.168.150.0_24"
          }
          BD_192_168_151_0_24 = {
            name = "192.168.151.0_24"
          }
          BD_192_168_152_0_24 = {
            name = "192.168.152.0_24"
          }
          BD_192_168_152_0_24 = {
            name = "192.168.152.0_24"
          }
        }
      }
      shared_services_tenant = {
        name = "shared-services"
        l3Out = {
          name = "shared-services.vrf-01-ospf-area-0.0.0.1"
          externalEPG = {
            name = "lab-desktops-subnets"
          }
        }
      }
    }
  }
  managed = {
    app_profile = {
      name = "online-boutique"
      esg = {
        name = "all-services"
        vm_tags = [
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-ad-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-cart-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-checkout-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-currency-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-email-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-frontend-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-payment-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-product-catalog-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-recommendation-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-shipping-service"
          },
          {
            key   = "Function"
            value = "tn-${var.TENANT_NAME}-online-boutique-redis-cart"
          }
        ]
      }
    }
    contracts = {
      permit_to_online_boutique_all_services = {
        name = "permit-to-online-boutique-all-services"
        scope = "global"
        exported_contract_name = "permit-to-tn-${var.TENANT_NAME}-online-boutique-all-services"
      }
    }
    filters = {
      tcp_src_any_dst_80_filter = {
        name = "tcp-src-any-dst-80"
      }
    }
    filter_entries = {
      tcp_src_any_dst_80_filter_entry = {
        name          = "tcp-src-any-dst-80"
        ether_t       = "ip"
        prot          = "tcp"
        d_from_port   = "80"
        d_to_port     = "80"   
      }
    }
  }
}
#   model = {
#     tenant_name      = "ciscolive-07"
#     vrf_name         = "vrf-01"
#     shared_services_tenant_name = "shared-services"
#     all_services_app_profile = {
#       app_profile_name = "online-boutique"
#       esg = {
#         name = "all-services"
#       }
#       esg_tags = [
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-ad-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-cart-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-checkout-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-currency-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-email-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-frontend-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-payment-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-productcatalog-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-recommendation-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-shipping-service"
#         },
#         {
#           key   = "Function"
#           value = "${var.TENANT_NAME}-online-boutique-redis-database"
#         }
#       ]
#     }
#     contracts = [
#       {
#         name = "permit-to-online-boutique-all-services"
#         scope = "global"
#         exported_contract_name = "permit-to-tn-ciscolive-07-online-boutique-all-services"
#       }
#     ]
#   }
# }


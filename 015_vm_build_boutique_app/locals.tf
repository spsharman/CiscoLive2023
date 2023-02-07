locals {
  microservices = yamldecode(file("${path.module}/microservices.yaml"))

  cartserviceregex             = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.cartservice.default_ip)
  cartservice_target           = "cartservice-${local.cartserviceregex[0]}-${local.cartserviceregex[1]}-${local.cartserviceregex[2]}-${local.cartserviceregex[3]}.nip.io"
  redis_cartregex              = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.redis_cart.default_ip)
  redis_cart_target            = "redis_cart-${local.redis_cartregex[0]}-${local.redis_cartregex[1]}-${local.redis_cartregex[2]}-${local.redis_cartregex[3]}.nip.io"
  shippingserviceregex         = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.shippingservice.default_ip)
  shippingservice_target       = "shippingservice-${local.shippingserviceregex[0]}-${local.shippingserviceregex[1]}-${local.shippingserviceregex[2]}-${local.shippingserviceregex[3]}.nip.io"
  emailserviceregex            = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.emailservice.default_ip)
  emailservice_target          = "emailservice-${local.emailserviceregex[0]}-${local.emailserviceregex[1]}-${local.emailserviceregex[2]}-${local.emailserviceregex[3]}.nip.io"
  currencyserviceregex         = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.currencyservice.default_ip)
  currencyservice_target       = "currencyservice-${local.currencyserviceregex[0]}-${local.currencyserviceregex[1]}-${local.currencyserviceregex[2]}-${local.currencyserviceregex[3]}.nip.io"
  productcatalogserviceregex   = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.productcatalogservice.default_ip)
  productcatalogservice_target = "productcatalogservice-${local.productcatalogserviceregex[0]}-${local.productcatalogserviceregex[1]}-${local.productcatalogserviceregex[2]}-${local.productcatalogserviceregex[3]}.nip.io"
  checkoutserviceregex         = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.checkoutservice.default_ip)
  checkoutservice_target       = "checkoutservice-${local.checkoutserviceregex[0]}-${local.checkoutserviceregex[1]}-${local.checkoutserviceregex[2]}-${local.checkoutserviceregex[3]}.nip.io"
  paymentserviceregex          = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.paymentservice.default_ip)
  paymentservice_target        = "paymentservice-${local.paymentserviceregex[0]}-${local.paymentserviceregex[1]}-${local.paymentserviceregex[2]}-${local.paymentserviceregex[3]}.nip.io"
  adserviceregex               = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.adservice.default_ip)
  adservice_target             = "adservice-${local.adserviceregex[0]}-${local.adserviceregex[1]}-${local.adserviceregex[2]}-${local.adserviceregex[3]}.nip.io"
  frontendregex                = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.frontend.default_ip)
  frontend_target              = "frontend-${local.frontendregex[0]}-${local.frontendregex[1]}-${local.frontendregex[2]}-${local.frontendregex[3]}.nip.io"
  recommendationserviceregex   = regex("([0-9]+).([0-9]+).([0-9]+).([0-9]+)", module.recommendationservice.default_ip)
  recommendationservice_target = "recommendationservice-${local.recommendationserviceregex[0]}-${local.recommendationserviceregex[1]}-${local.recommendationserviceregex[2]}-${local.recommendationserviceregex[3]}.nip.io"
}
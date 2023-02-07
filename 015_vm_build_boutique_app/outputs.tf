output "redis_cart_vm_ip" {
  description = "redis-cart VM IP address"
  value       = module.redis_cart.default_ip
}

output "shippingservice_vm_ip" {
  description = "shippingservice VM IP address"
  value       = module.shippingservice.default_ip
}

output "emailservice_vm_ip" {
  description = "emailservice VM IP address"
  value       = module.emailservice.default_ip
}

output "currencyservice_vm_ip" {
  description = "currencyservice VM IP address"
  value       = module.currencyservice.default_ip
}


output "productcatalogservice_vm_ip" {
  description = "productcatalogservice VM IP address"
  value       = module.productcatalogservice.default_ip
}

output "checkoutservice_vm_ip" {
  description = "checkoutservice VM IP address"
  value       = module.checkoutservice.default_ip
}

output "paymentservice_vm_ip" {
  description = "paymentservice VM IP address"
  value       = module.paymentservice.default_ip
}

output "adservice_vm_ip" {
  description = "adservice VM IP address"
  value       = module.adservice.default_ip
}

output "frontend_vm_ip" {
  description = "frontend VM IP address"
  value       = module.frontend.default_ip
}

output "recommendationservice_vm_ip" {
  description = "recommendationservice VM IP address"
  value       = module.recommendationservice.default_ip
}

output "cartservice_vm_ip" {
  description = "cartservice VM IP address"
  value       = module.cartservice.default_ip
}
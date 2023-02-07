#########################################################
# vSphere datacenter
#########################################################
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

#########################################################
# Create vSphere subfolders
#########################################################
resource "vsphere_folder" "app_folder" {
  path          = "${var.vm_folder_root}/${var.prefix}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "frontend" {
  path          = "${vsphere_folder.app_folder.path}/frontend"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "middleware" {
  path          = "${vsphere_folder.app_folder.path}/middleware"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "backend" {
  path          = "${vsphere_folder.app_folder.path}/backend"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

#########################################################
# Read vSphere tag category
#########################################################
data "vsphere_tag_category" "tag_category" {
  name = "Function"
}

#########################################################
# Create new vSphere tags to match ESG selectors
#########################################################
resource "vsphere_tag" "shippingservice_tag" {
  name        = "${var.prefix}-online-boutique-shipping-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "cartservice_tag" {
  name        = "${var.prefix}-online-boutique-cart-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "redis_tag" {
  name        = "${var.prefix}-online-boutique-redis-database"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "emailservice_tag" {
  name        = "${var.prefix}-online-boutique-email-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "currencyservice_tag" {
  name        = "${var.prefix}-online-boutique-currency-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "productcatalogservice_tag" {
  name        = "${var.prefix}-online-boutique-productcatalog-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "checkoutservice_tag" {
  name        = "${var.prefix}-online-boutique-checkout-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "paymentservice_tag" {
  name        = "${var.prefix}-online-boutique-payment-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "adservice_tag" {
  name        = "${var.prefix}-online-boutique-ad-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "frontend_tag" {
  name        = "${var.prefix}-online-boutique-frontend-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

resource "vsphere_tag" "recommendationservice_tag" {
  name        = "${var.prefix}-online-boutique-recommendation-service"
  category_id = data.vsphere_tag_category.tag_category.id
}

#########################################################
# DEPLOY VMs
#########################################################
# cartservice
#########################################################
module "cartservice" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.cartservice.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.cartservice.vsphere_cluster
  vsphere_datastore       = local.microservices.cartservice.vsphere_datastore
  vsphere_network         = local.microservices.cartservice.vsphere_network
  vm_template_name        = local.microservices.cartservice.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.cartservice.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.cartservice.vm_hostname}"
  domain          = local.microservices.cartservice.domain
  ip_address      = local.microservices.cartservice.ipv4_address
  netmask_cidr    = local.microservices.cartservice.ipv4_netmask
  gateway         = local.microservices.cartservice.ipv4_gateway
  dns_server_list = local.microservices.cartservice.dns_server_list
  dns_suffix_list = local.microservices.cartservice.dns_suffix_list
  vm_folder       = vsphere_folder.middleware.path
  num_cpus        = local.microservices.cartservice.num_cpus
  mem_gb          = local.microservices.cartservice.mem_gb
  tag_id          = vsphere_tag.cartservice_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name cartservice --env PORT=7070 --env REDIS_ADDR=\"${local.redis_cart_target}:6379\" --network netboutique -p 7070:7070 gcr.io/google-samples/microservices-demo/cartservice:v0.3.7"

}

#########################################################
# redis-cart 
##########################################################
module "redis_cart" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.redis-cart.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.redis-cart.vsphere_cluster
  vsphere_datastore       = local.microservices.redis-cart.vsphere_datastore
  vsphere_network         = local.microservices.redis-cart.vsphere_network
  vm_template_name        = local.microservices.redis-cart.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.redis-cart.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.redis-cart.vm_hostname}"
  domain          = local.microservices.redis-cart.domain
  ip_address      = local.microservices.redis-cart.ipv4_address
  netmask_cidr    = local.microservices.redis-cart.ipv4_netmask
  gateway         = local.microservices.redis-cart.ipv4_gateway
  dns_server_list = local.microservices.redis-cart.dns_server_list
  dns_suffix_list = local.microservices.redis-cart.dns_suffix_list
  vm_folder       = vsphere_folder.backend.path
  num_cpus        = local.microservices.redis-cart.num_cpus
  mem_gb          = local.microservices.redis-cart.mem_gb
  tag_id          = vsphere_tag.redis_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name redis-cart --network netboutique -p 6379:6379 redis:alpine"

}

#########################################################
# shippingservice
##########################################################
module "shippingservice" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.shippingservice.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.shippingservice.vsphere_cluster
  vsphere_datastore       = local.microservices.shippingservice.vsphere_datastore
  vsphere_network         = local.microservices.shippingservice.vsphere_network
  vm_template_name        = local.microservices.shippingservice.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.shippingservice.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.shippingservice.vm_hostname}"
  domain          = local.microservices.shippingservice.domain
  ip_address      = local.microservices.shippingservice.ipv4_address
  netmask_cidr    = local.microservices.shippingservice.ipv4_netmask
  gateway         = local.microservices.shippingservice.ipv4_gateway
  dns_server_list = local.microservices.shippingservice.dns_server_list
  dns_suffix_list = local.microservices.shippingservice.dns_suffix_list
  vm_folder       = vsphere_folder.middleware.path
  num_cpus        = local.microservices.shippingservice.num_cpus
  mem_gb          = local.microservices.shippingservice.mem_gb
  tag_id          = vsphere_tag.shippingservice_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name shippingservice --env PORT=50051 --env DISABLE_STATS=1 --env DISABLE_TRACING=1 --env DISABLE_PROFILER=1 --network netboutique -p 50051:50051 gcr.io/google-samples/microservices-demo/shippingservice:v0.3.7"

}

#########################################################
# emailservice
##########################################################
module "emailservice" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.emailservice.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.emailservice.vsphere_cluster
  vsphere_datastore       = local.microservices.emailservice.vsphere_datastore
  vsphere_network         = local.microservices.emailservice.vsphere_network
  vm_template_name        = local.microservices.emailservice.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.emailservice.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.emailservice.vm_hostname}"
  domain          = local.microservices.emailservice.domain
  ip_address      = local.microservices.emailservice.ipv4_address
  netmask_cidr    = local.microservices.emailservice.ipv4_netmask
  gateway         = local.microservices.emailservice.ipv4_gateway
  dns_server_list = local.microservices.emailservice.dns_server_list
  dns_suffix_list = local.microservices.emailservice.dns_suffix_list
  vm_folder       = vsphere_folder.middleware.path
  num_cpus        = local.microservices.emailservice.num_cpus
  mem_gb          = local.microservices.emailservice.mem_gb
  tag_id          = vsphere_tag.emailservice_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name emailservice --env PORT=8080 --env DISABLE_TRACING=1 --env DISABLE_PROFILER=1 --network netboutique -p 5000:8080 gcr.io/google-samples/microservices-demo/emailservice:v0.3.7"

}

#########################################################
# currencyservice
##########################################################
module "currencyservice" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.currencyservice.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.currencyservice.vsphere_cluster
  vsphere_datastore       = local.microservices.currencyservice.vsphere_datastore
  vsphere_network         = local.microservices.currencyservice.vsphere_network
  vm_template_name        = local.microservices.currencyservice.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.currencyservice.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.currencyservice.vm_hostname}"
  domain          = local.microservices.currencyservice.domain
  ip_address      = local.microservices.currencyservice.ipv4_address
  netmask_cidr    = local.microservices.currencyservice.ipv4_netmask
  gateway         = local.microservices.currencyservice.ipv4_gateway
  dns_server_list = local.microservices.currencyservice.dns_server_list
  dns_suffix_list = local.microservices.currencyservice.dns_suffix_list
  vm_folder       = vsphere_folder.middleware.path
  num_cpus        = local.microservices.currencyservice.num_cpus
  mem_gb          = local.microservices.currencyservice.mem_gb
  tag_id          = vsphere_tag.currencyservice_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name currencyservice --env PORT=7000 --env DISABLE_DEBUGGER=1 --env DISABLE_TRACING=1 --env DISABLE_PROFILER=1 --network netboutique -p 7000:7000 gcr.io/google-samples/microservices-demo/currencyservice:v0.3.7"

}

#########################################################
# productcatalogservice
##########################################################
module "productcatalogservice" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.productcatalogservice.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.productcatalogservice.vsphere_cluster
  vsphere_datastore       = local.microservices.productcatalogservice.vsphere_datastore
  vsphere_network         = local.microservices.productcatalogservice.vsphere_network
  vm_template_name        = local.microservices.productcatalogservice.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.productcatalogservice.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.productcatalogservice.vm_hostname}"
  domain          = local.microservices.productcatalogservice.domain
  ip_address      = local.microservices.productcatalogservice.ipv4_address
  netmask_cidr    = local.microservices.productcatalogservice.ipv4_netmask
  gateway         = local.microservices.productcatalogservice.ipv4_gateway
  dns_server_list = local.microservices.productcatalogservice.dns_server_list
  dns_suffix_list = local.microservices.productcatalogservice.dns_suffix_list
  vm_folder       = vsphere_folder.middleware.path
  num_cpus        = local.microservices.productcatalogservice.num_cpus
  mem_gb          = local.microservices.productcatalogservice.mem_gb
  tag_id          = vsphere_tag.productcatalogservice_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name productcatalogservice --env PORT=3550 --env DISABLE_STATS=1 --env DISABLE_TRACING=1 --env DISABLE_PROFILER=1 --network netboutique -p 3550:3550 gcr.io/google-samples/microservices-demo/productcatalogservice:v0.3.7"

}

#########################################################
# checkoutservice
##########################################################
module "checkoutservice" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.checkoutservice.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.checkoutservice.vsphere_cluster
  vsphere_datastore       = local.microservices.checkoutservice.vsphere_datastore
  vsphere_network         = local.microservices.checkoutservice.vsphere_network
  vm_template_name        = local.microservices.checkoutservice.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.checkoutservice.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.checkoutservice.vm_hostname}"
  domain          = local.microservices.checkoutservice.domain
  ip_address      = local.microservices.checkoutservice.ipv4_address
  netmask_cidr    = local.microservices.checkoutservice.ipv4_netmask
  gateway         = local.microservices.checkoutservice.ipv4_gateway
  dns_server_list = local.microservices.checkoutservice.dns_server_list
  dns_suffix_list = local.microservices.checkoutservice.dns_suffix_list
  vm_folder       = vsphere_folder.middleware.path
  num_cpus        = local.microservices.checkoutservice.num_cpus
  mem_gb          = local.microservices.checkoutservice.mem_gb
  tag_id          = vsphere_tag.checkoutservice_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name checkoutservice --env PORT=5050 --env PRODUCT_CATALOG_SERVICE_ADDR=\"${local.productcatalogservice_target}:3550\" --env SHIPPING_SERVICE_ADDR=\"${local.shippingservice_target}:50051\" --env PAYMENT_SERVICE_ADDR=\"${local.paymentservice_target}:50051\" --env EMAIL_SERVICE_ADDR=\"${local.emailservice_target}:5000\" --env CURRENCY_SERVICE_ADDR=\"${local.currencyservice_target}:7000\" --env CART_SERVICE_ADDR=\"${local.cartservice_target}:7070\" --env DISABLE_STATS=1 --env DISABLE_TRACING=1 --env DISABLE_PROFILER=1 --network netboutique -p 5050:5050 gcr.io/google-samples/microservices-demo/checkoutservice:v0.3.7"

}

#########################################################
# paymentservice
##########################################################
module "paymentservice" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.paymentservice.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.paymentservice.vsphere_cluster
  vsphere_datastore       = local.microservices.paymentservice.vsphere_datastore
  vsphere_network         = local.microservices.paymentservice.vsphere_network
  vm_template_name        = local.microservices.paymentservice.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.paymentservice.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.paymentservice.vm_hostname}"
  domain          = local.microservices.paymentservice.domain
  ip_address      = local.microservices.paymentservice.ipv4_address
  netmask_cidr    = local.microservices.paymentservice.ipv4_netmask
  gateway         = local.microservices.paymentservice.ipv4_gateway
  dns_server_list = local.microservices.paymentservice.dns_server_list
  dns_suffix_list = local.microservices.paymentservice.dns_suffix_list
  vm_folder       = vsphere_folder.middleware.path
  num_cpus        = local.microservices.paymentservice.num_cpus
  mem_gb          = local.microservices.paymentservice.mem_gb
  tag_id          = vsphere_tag.paymentservice_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name paymentservice --env PORT=50051 --env PRODUCT_CATALOG_SERVICE_ADDR=\"${local.productcatalogservice_target}:3550\" --env CURRENCY_SERVICE_ADDR=\"${local.currencyservice_target}:7000\" --env CART_SERVICE_ADDR=\"${local.cartservice_target}:7070\" --env RECOMMENDATION_SERVICE_ADDR=\"${local.recommendationservice_target}:8080\" --env SHIPPING_SERVICE_ADDR=\"${local.shippingservice_target}:50051\" --env CHECKOUT_SERVICE_ADDR=\"${local.checkoutservice_target}:5050\" --env AD_SERVICE_ADDR=\"${local.adservice_target}:9555\" --env DISABLE_DEBUGGER=1 --env DISABLE_TRACING=1 --env DISABLE_PROFILER=1 --network netboutique -p 50051:50051 gcr.io/google-samples/microservices-demo/paymentservice:v0.3.7"

}

#########################################################
# adservice
##########################################################
module "adservice" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.adservice.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.adservice.vsphere_cluster
  vsphere_datastore       = local.microservices.adservice.vsphere_datastore
  vsphere_network         = local.microservices.adservice.vsphere_network
  vm_template_name        = local.microservices.adservice.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.adservice.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.adservice.vm_hostname}"
  domain          = local.microservices.adservice.domain
  ip_address      = local.microservices.adservice.ipv4_address
  netmask_cidr    = local.microservices.adservice.ipv4_netmask
  gateway         = local.microservices.adservice.ipv4_gateway
  dns_server_list = local.microservices.adservice.dns_server_list
  dns_suffix_list = local.microservices.adservice.dns_suffix_list
  vm_folder       = vsphere_folder.middleware.path
  num_cpus        = local.microservices.adservice.num_cpus
  mem_gb          = local.microservices.adservice.mem_gb
  tag_id          = vsphere_tag.adservice_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name adservice --env PORT=9555 --env DISABLE_STATS=1 --env DISABLE_TRACING=1 --network netboutique -p 9555:9555 gcr.io/google-samples/microservices-demo/adservice:v0.3.7"


}

#########################################################
# frontend
##########################################################
module "frontend" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.frontend.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.frontend.vsphere_cluster
  vsphere_datastore       = local.microservices.frontend.vsphere_datastore
  vsphere_network         = local.microservices.frontend.vsphere_network
  vm_template_name        = local.microservices.frontend.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.frontend.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.frontend.vm_hostname}"
  domain          = local.microservices.frontend.domain
  ip_address      = local.microservices.frontend.ipv4_address
  netmask_cidr    = local.microservices.frontend.ipv4_netmask
  gateway         = local.microservices.frontend.ipv4_gateway
  dns_server_list = local.microservices.frontend.dns_server_list
  dns_suffix_list = local.microservices.frontend.dns_suffix_list
  vm_folder       = vsphere_folder.frontend.path
  num_cpus        = local.microservices.frontend.num_cpus
  mem_gb          = local.microservices.frontend.mem_gb
  tag_id          = vsphere_tag.frontend_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name frontend --env PORT=8080 --env PRODUCT_CATALOG_SERVICE_ADDR=\"${local.productcatalogservice_target}:3550\" --env CURRENCY_SERVICE_ADDR=\"${local.currencyservice_target}:7000\" --env CART_SERVICE_ADDR=\"${local.cartservice_target}:7070\" --env RECOMMENDATION_SERVICE_ADDR=\"${local.recommendationservice_target}:8080\" --env SHIPPING_SERVICE_ADDR=\"${local.shippingservice_target}:50051\" --env CHECKOUT_SERVICE_ADDR=\"${local.checkoutservice_target}:5050\" --env AD_SERVICE_ADDR=\"${local.adservice_target}:9555\" --env ENV_PLATFORM=\"onprem\" --env DISABLE_TRACING=1 --env DISABLE_PROFILER=1 --network netboutique -p 80:8080 gcr.io/google-samples/microservices-demo/frontend:v0.3.7"

}

#########################################################
# recommendationservice
##########################################################
module "recommendationservice" {
  source = "./modules/vm_deploy"

  vsphere_datacenter      = local.microservices.recommendationservice.vsphere_datacenter
  vsphere_compute_cluster = local.microservices.recommendationservice.vsphere_cluster
  vsphere_datastore       = local.microservices.recommendationservice.vsphere_datastore
  vsphere_network         = local.microservices.recommendationservice.vsphere_network
  vm_template_name        = local.microservices.recommendationservice.vm_template_name
  vm_username             = var.vm_username
  vm_password             = var.vm_password

  vm_name         = "${var.prefix}-${local.microservices.recommendationservice.vm_name}"
  host_name       = "${var.prefix}-${local.microservices.recommendationservice.vm_hostname}"
  domain          = local.microservices.recommendationservice.domain
  ip_address      = local.microservices.recommendationservice.ipv4_address
  netmask_cidr    = local.microservices.recommendationservice.ipv4_netmask
  gateway         = local.microservices.recommendationservice.ipv4_gateway
  dns_server_list = local.microservices.recommendationservice.dns_server_list
  dns_suffix_list = local.microservices.recommendationservice.dns_suffix_list
  vm_folder       = vsphere_folder.middleware.path
  num_cpus        = local.microservices.recommendationservice.num_cpus
  mem_gb          = local.microservices.recommendationservice.mem_gb
  tag_id          = vsphere_tag.recommendationservice_tag.id

  docker_cmd = "docker network create --driver bridge netboutique && docker run -d --restart always --name recommendationservice --env PORT=8080 --env PRODUCT_CATALOG_SERVICE_ADDR=\"${local.productcatalogservice_target}:3550\" --env DISABLE_DEBUGGER=1 --env DISABLE_TRACING=1 --env DISABLE_PROFILER=1 --network netboutique -p 8080:8080 gcr.io/google-samples/microservices-demo/recommendationservice:v0.3.7"

}

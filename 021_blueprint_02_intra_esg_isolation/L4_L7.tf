data "aci_l4_l7_device" "ftdv_device" {
  tenant_dn  = data.aci_tenant.shared_services_tenant.id
  name       = local.model.l4_l7.device_name
}

###############################################################
## Import Concrete device from shared services into user tenant
## [tenant->Services->L4-L7->Imported Devices]
###############################################################
resource "aci_rest_managed" "import_device" {
  dn         = "uni/tn-${local.model.tenant_name}/lDevIf-[${data.aci_l4_l7_device.ftdv_device.id}]"
  class_name = "vnsLDevIf"
  content = {
    ldev = data.aci_l4_l7_device.ftdv_device.id
  }
}

###############################################################
## Policy-Based-Redirect Policy
## [tenant->Policies->Protocol->L4-L7 Policy-Based Redirect]
###############################################################
resource "aci_service_redirect_policy" "pbr_policy" {
  tenant_dn               = data.aci_tenant.user_tenant.id
  name                    = local.model.l4_l7.pbr_policy.name
  dest_type               = local.model.l4_l7.pbr_policy.dest_type
  hashing_algorithm       = local.model.l4_l7.pbr_policy.hashing_algorithm
}

resource "aci_destination_of_redirected_traffic" "pbr_policy_dest" {
  service_redirect_policy_dn  = aci_service_redirect_policy.pbr_policy.id
  ip                          = local.model.l4_l7.pbr_policy.L3_destination.ftdv_ip
  mac                         = local.model.l4_l7.pbr_policy.L3_destination.ftdv_mac
}

###############################################################
## Service Graph Template
## [tenant->Services->L4-L7->Service Graph Templates]
###############################################################
resource "aci_l4_l7_service_graph_template" "service_graph_template" {
  tenant_dn                         = data.aci_tenant.user_tenant.id
  name                              = local.model.l4_l7.service_graph_template.name
}

####################################################################
## Service Graph Template Function Node
## [tenant->Services->L4-L7->Service Graph Templates->Function Node]
####################################################################
resource "aci_function_node" "service_graph_template_function_node" {
  l4_l7_service_graph_template_dn  = aci_l4_l7_service_graph_template.service_graph_template.id
  name  = local.model.l4_l7.service_graph_template.function_node.name
  func_template_type  = local.model.l4_l7.service_graph_template.function_node.template_type
  func_type  = local.model.l4_l7.service_graph_template.function_node.function_type
  managed  = "no"
  routing_mode  = "Redirect"
  relation_vns_rs_node_to_l_dev = aci_rest_managed.import_device.id
}

####################################################################
## Service Graph Template Terminal Node to Connection
## [tenant->Services->L4-L7->Service Graph Templates->Function Node]
####################################################################
resource "aci_connection" "t1-n1" {
    l4_l7_service_graph_template_dn = aci_l4_l7_service_graph_template.service_graph_template.id
    name                            = "C2"
    adj_type                        = "L3"
    conn_dir                        = "provider"
    conn_type                       = "external"
    direct_connect                  = "no"
    unicast_route                   = "yes"
    relation_vns_rs_abs_connection_conns = [
        aci_l4_l7_service_graph_template.service_graph_template.term_prov_dn,
        aci_function_node.service_graph_template_function_node.conn_provider_dn
    ]
}

####################################################################
## Service Graph Template Connection to Terminal Node
## [tenant->Services->L4-L7->Service Graph Templates->Function Node]
####################################################################
resource "aci_connection" "n1-t2" {
    l4_l7_service_graph_template_dn = aci_l4_l7_service_graph_template.service_graph_template.id
    name                            = "C1"
    adj_type                        = "L3"
    conn_dir                        = "provider"
    conn_type                       = "external"
    direct_connect                  = "no"
    unicast_route                   = "yes"
    relation_vns_rs_abs_connection_conns = [
        aci_l4_l7_service_graph_template.service_graph_template.term_cons_dn,
        aci_function_node.service_graph_template_function_node.conn_consumer_dn
    ]
}

##############################################################################
## Service Graph Template Connection to Terminal Node
## [tenant->Services->L4-L7->Service Graph Templates->Function Node->consumer]
## Apply filter
##############################################################################
resource "aci_rest_managed" "vnsAbsFuncConn-consumer" {
  dn         = "${aci_function_node.service_graph_template_function_node.conn_consumer_dn}/rsConnToFlt"
  class_name = "vnsRsConnToFlt"
  content = {
    tDn = "${data.aci_tenant.user_tenant.id}/flt-permit-any"
  }

  depends_on = [
    aci_l4_l7_service_graph_template.service_graph_template,
    aci_function_node.service_graph_template_function_node,
    aci_connection.t1-n1,
    aci_connection.n1-t2
  ]
}

##############################################################################
## Service Graph Template Connection to Terminal Node
## [tenant->Services->L4-L7->Service Graph Templates->Function Node->provider]
## Apply filter
##############################################################################
resource "aci_rest_managed" "vnsAbsFuncConn-provider" {
  dn         = "${aci_function_node.service_graph_template_function_node.conn_provider_dn}/rsConnToFlt"
  class_name = "vnsRsConnToFlt"
  content = {
    tDn = "${data.aci_tenant.user_tenant.id}/flt-permit-any"
  }

  depends_on = [
    aci_l4_l7_service_graph_template.service_graph_template,
    aci_function_node.service_graph_template_function_node,
    aci_connection.t1-n1,
    aci_connection.n1-t2
  ]
}

###############################################################
## Device Selection Policy (All Services)
## [tenant->Services->L4-L7->Device Selection Policies]
###############################################################
resource "aci_logical_device_context" "all_services_isolated" {
  tenant_dn         = data.aci_tenant.user_tenant.id
  ctrct_name_or_lbl = aci_contract.permit_to_online_boutique_all_services_isolated.name
  graph_name_or_lbl = aci_l4_l7_service_graph_template.service_graph_template.name
  node_name_or_lbl  = aci_function_node.service_graph_template_function_node.name
  relation_vns_rs_l_dev_ctx_to_l_dev = "${data.aci_tenant.user_tenant.id}/lDevIf-[${data.aci_l4_l7_device.ftdv_device.id}]"
}
resource "aci_logical_interface_context" "service_consumer" {
  logical_device_context_dn  = aci_logical_device_context.all_services_isolated.id
  conn_name_or_lbl  = "consumer"
  l3_dest  = "no"
  permit_log  = "no"
  relation_vns_rs_l_if_ctx_to_svc_redirect_pol = aci_service_redirect_policy.pbr_policy.id
  relation_vns_rs_l_if_ctx_to_l_if = "${data.aci_tenant.user_tenant.id}/lDevIf-[${data.aci_l4_l7_device.ftdv_device.id}]/lDevIfLIf-gig-0-3"
  relation_vns_rs_l_if_ctx_to_bd = data.aci_bridge_domain.bd_10_0_75_0_24.id
}
resource "aci_logical_interface_context" "service_provider" {
  logical_device_context_dn  = aci_logical_device_context.all_services_isolated.id
  conn_name_or_lbl  = "provider"
  l3_dest  = "no"
  permit_log  = "no"
  relation_vns_rs_l_if_ctx_to_svc_redirect_pol = aci_service_redirect_policy.pbr_policy.id
  relation_vns_rs_l_if_ctx_to_l_if = "${data.aci_tenant.user_tenant.id}/lDevIf-[${data.aci_l4_l7_device.ftdv_device.id}]/lDevIfLIf-gig-0-3"
  relation_vns_rs_l_if_ctx_to_bd = data.aci_bridge_domain.bd_10_0_75_0_24.id
}

##################################################################################################
# Enable Contract redirect to Service Graph
# [tenant->Contracts->Standard->permit-to-online-boutique-all-services-isolated-service->redirect]
##################################################################################################
resource "aci_rest_managed" "enable_all_services_isolated_svc_service_graph" {
  dn         = "${aci_contract_subject.permit_to_online_boutique_all_services_isolated_subject_all_services.id}/rsSubjGraphAtt"
  class_name = "vzRsSubjGraphAtt"
  content = {
    tnVnsAbsGraphName = aci_l4_l7_service_graph_template.service_graph_template.name
  }

  depends_on = [
    aci_logical_device_context.all_services_isolated,
    aci_logical_interface_context.service_consumer,
    aci_logical_interface_context.service_provider
  ]
}




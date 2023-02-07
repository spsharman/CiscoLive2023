data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder

  num_cpus = var.num_cpus
  memory   = var.mem_gb
  guest_id = "centos8_64Guest"

  firmware = "efi"

  tags = [var.tag_id]

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = data.vsphere_virtual_machine.template.disks.0.size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.host_name
        domain    = var.domain
      }

      network_interface {
        ipv4_address = var.ip_address
        ipv4_netmask = var.netmask_cidr
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_server_list
      dns_suffix_list = var.dns_suffix_list
    }
  }
}

resource "null_resource" "start_microservice" {
  triggers = {
    vm_ip    = vsphere_virtual_machine.vm.default_ip_address
    username = var.vm_username
    passwd   = var.vm_password
  }

  provisioner "remote-exec" {
    inline = [var.docker_cmd]
    connection {
      type     = "ssh"
      user     = self.triggers.username
      password = self.triggers.passwd
      host     = self.triggers.vm_ip
    }
  }

  depends_on = [
    vsphere_virtual_machine.vm
  ]
}




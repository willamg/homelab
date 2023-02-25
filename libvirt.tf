resource "libvirt_volume" "base" {
  name   = "centos8.qcow2"
  pool   = "default"
  source = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20201217.0.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "centos8-qcow2" {
  name           = "test-os_image-${count.index + 1}"
  base_volume_id = libvirt_volume.base.id
  pool           = "default"
  size           = var.size
  count          = var.disk_count

}

# Use CloudInit to add our ssh-key to the instance
resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  pool      = "default" #CHANGEME
  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

# Define KVM domain to create
resource "libvirt_domain" "centovm" {
  name   = "rancher-vm-${count.index + 1}"
  memory = var.memory
  vcpu   = var.cpu_count
  count  = var.instance_count

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name   = "default"
    hostname       = "rancher"
    wait_for_lease = true
  }

  disk {
    volume_id = element(libvirt_volume.centos8-qcow2.*.id, count.index)
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# Output Server IP
output "ips" {
  value = flatten(libvirt_domain.centovm.*.network_interface.0.addresses)
}



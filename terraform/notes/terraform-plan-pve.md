# Terraform sample plan for PVE VM
- testing terraform

Terraform will perform the following actions:

```
Terraform will perform the following actions:

  # proxmox_vm_qemu.vm-deploy-1 will be created
  + resource "proxmox_vm_qemu" "vm-deploy-1" {
      + additional_wait        = 5
      + agent                  = 1
      + agent_timeout          = 90
      + automatic_reboot       = false
      + balloon                = 1024
      + bios                   = "seabios"
      + boot                   = "order=virtio0"
      + bootdisk               = (known after apply)
      + cipassword             = (sensitive value)
      + ciupgrade              = false
      + ciuser                 = "luca"
      + clone                  = "debian12-template"
      + clone_wait             = 10
      + cores                  = 2
      + cpu_type               = "host"
      + current_node           = (known after apply)
      + default_ipv4_address   = (known after apply)
      + default_ipv6_address   = (known after apply)
      + define_connection_info = true
      + desc                   = "A test for using terraform and cloudinit"
      + force_create           = false
      + full_clone             = true
      + hotplug                = "network,disk,usb"
      + id                     = (known after apply)
      + ipconfig0              = "ip=10.0.1.6/24,gw=10.0.1.254"
      + kvm                    = true
      + linked_vmid            = (known after apply)
      + memory                 = 2048
      + name                   = "debian12-cloud"
      + nameserver             = "10.0.6.1"
      + onboot                 = true
      + protection             = false
      + qemu_os                = "other"
      + reboot_required        = (known after apply)
      + scsihw                 = "virtio-scsi-single"
      + skip_ipv4              = false
      + skip_ipv6              = false
      + sockets                = 1
      + ssh_host               = (known after apply)
      + ssh_port               = (known after apply)
      + sshkeys                = (sensitive value)
      + tablet                 = true
      + tags                   = (known after apply)
      + target_node            = "pve"
      + unused_disk            = (known after apply)
      + vcpus                  = 0
      + vm_state               = "running"
      + vmid                   = 106
        # (1 unchanged attribute hidden)

      + disks {
          + ide {
              + ide3 {
                  + cloudinit {
                      + storage = "local-lvm"
                    }
                }
            }
          + virtio {
              + virtio0 {
                  + disk {
                      + backup               = true
                      + cache                = "writeback"
                      + discard              = true
                      + format               = "raw"
                      + id                   = (known after apply)
                      + iops_r_burst         = 0
                      + iops_r_burst_length  = 0
                      + iops_r_concurrent    = 0
                      + iops_wr_burst        = 0
                      + iops_wr_burst_length = 0
                      + iops_wr_concurrent   = 0
                      + iothread             = true
                      + linked_disk_id       = (known after apply)
                      + mbps_r_burst         = 0
                      + mbps_r_concurrent    = 0
                      + mbps_wr_burst        = 0
                      + mbps_wr_concurrent   = 0
                      + size                 = "20"
                      + storage              = "local-lvm"
                    }
                }
            }
        }

      + network {
          + bridge    = "vmbr2"
          + firewall  = false
          + id        = 0
          + link_down = false
          + macaddr   = (known after apply)
          + model     = "virtio"
        }

      + serial {
          + id   = 0
          + type = "socket"
        }

      + smbios (known after apply)
    }
```
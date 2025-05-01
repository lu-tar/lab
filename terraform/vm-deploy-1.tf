#Reference: https://github.com/ChristianLempa/boilerplates/blob/main/terraform/proxmox/vm_qemu.tf
resource "proxmox_vm_qemu" "your-vm" {
  name = "debian12-template"
  desc = "description"
  agent = 1  # <-- (Optional) Enable QEMU Guest Agent
  target_node = "pve"
  vmid = "100"
  clone = "debian-tf"
  full_clone = true
  onboot = true
  startup = ""
  automatic_reboot = false

  qemu_os = "other"
  bios = "seabios"
  cores = 2
  sockets = 1
  cpu_type = "host"
  memory = 2048
  balloon = 1024

  network {
    id     = 0  # NOTE Required since 3.x.x
    bridge = "vmbr2"
    model  = "virtio"
  }
    
  scsihw = "virtio-scsi-single"

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "local-lvm"

          # NOTE Since 3.x.x size change disk size will trigger a disk resize
          size = "20G"

          iothread = true
          replicate = false
        }
      }
    }
  }

  ipconfig0 = "ip=10.0.1.6/0,gw=10.0.1.254"
  nameserver = "10.0.6.1"
  ciuser = "your-username"
  sshkeys = var.PUBLIC_SSH_KEY

}
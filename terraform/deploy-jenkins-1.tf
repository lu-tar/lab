resource "proxmox_vm_qemu" "vm-deploy-1" {
    name = "tf-debian12-cloud"
    # Notes inside PVE GUI
    desc = "A test for using terraform and cloudinit"

    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"
    vmid = 401

    # The destination resource pool for the new VM
    #pool = "pool0"

    # The template name to clone this vm from
    clone = "debian12-template"
    full_clone = true

    # Activate QEMU agent for this VM
    agent = 1

    qemu_os = "other"
    bios = "seabios"
    cores = 2
    sockets = 1
    cpu_type = "host"
    memory = 2048
    balloon = 0

    automatic_reboot = false
    startup = ""
    onboot = true
    vm_state = "running"

    scsihw = "virtio-scsi-single"

    serial {
        id   = 0
        type = "socket"
    }

    # Setup the disk
    disks {
        ide {
            ide3 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        # Check if virtio is better, exluding stats due to template cloning
        scsi {
            scsi0 {
                disk {
                    size            = 20
                    cache           = "writeback"
                    storage         = "local-lvm"
                    #storage_type    = "rbd"
                    #iothread        = true
                    #discard         = true
                }
            }
        }
    }

    # Setup the network interface and assign a vlan tag: 256
    network {
        id = 0
        model = "virtio"
        firewall = false
        bridge = "vmbr2"
        #tag = 256
    }

    # Setup the ip address using cloud-init.
    boot = "order=scsi0"
    ipconfig0 = "ip=10.0.4.2/24,gw=10.0.4.254"
    nameserver = "10.0.6.1"
    ciuser = "luca"
    sshkeys = var.PUBLIC_SSH_KEY
    cipassword = var.CI_PASSWORD

    #sshkeys = <<EOF
    #ssh-rsa 9182739187293817293817293871== user@pc
    #EOF
}
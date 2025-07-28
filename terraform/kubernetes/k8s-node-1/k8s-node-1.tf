# ------------K8S CONTROL PLANE------------
resource "proxmox_vm_qemu" "k8s-control-1" {
    name = "k8s-node-1"
    # Notes inside PVE GUI
    desc = "K8S Worker Node 1 - ip=10.0.1.8/24,gw=10.0.1.254"

    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"
    vmid = 108

    # The destination resource pool for the new VM
    #pool = "pool0"

    # The template name to clone this vm from
    clone = "debian12-template"
    full_clone = true

    # Activate QEMU agent for this VM
    agent = 1

    qemu_os = "other"
    bios = "seabios"
    cores = 4
    sockets = 2
    cpu_type = "host"
    memory = 6144
    balloon = 0

    automatic_reboot = false
    startup = ""
    onboot = true
    vm_state = "running"

    scsihw = "virtio-scsi-single"

    #cloudinit_userdata = file("../cloud_init.yaml")

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
                    size            = 50
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
    ipconfig0 = "ip=10.0.1.8/24,gw=10.0.1.254"
    nameserver = "10.0.6.1"
    ciuser = "luca"
    sshkeys = var.PUBLIC_SSH_KEY
    cipassword = var.CI_PASSWORD

    #sshkeys = <<EOF
    #ssh-rsa 9182739187293817293817293871== user@pc
    #EOF
}
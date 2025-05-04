resource "proxmox_lxc" "lxc-debian-1" {
    features {
        nesting = true
    }
    hostname = "tf-debian12"
    network {
        name = "eth0"
        bridge = "vmbr2"
        # Setting statico non supportato
        ip = "dhcp"
    }
    # NB Capire come gestire anche il load dell'os
    ostemplate = "shared:vztmpl/debian-12-standard_12.7.1_amd64.tar.zst"
    password = var.CI_PASSWORD
    #pool = "terraform"
    target_node = "pve"
    unprivileged = true
    vmid = 107
}
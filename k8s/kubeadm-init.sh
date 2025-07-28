#!/bin/bash
set -euo pipefail

# Funzione di log colorato
log() {
  echo -e "\033[1;34m[INFO]\033[0m $1"
}
warn() {
  echo -e "\033[1;33m[WARN]\033[0m $1"
}
error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1"
}

log "Update and upgrade system"
sudo apt update -y && sudo apt upgrade -y

# Potenzialmente setuppare anche: helm e k9s
log "Apt install: cron, jq, git, apt-transport-https"
log "Apt install: ca-certificates, curl, gpg, software-properties-common"
sudo apt install -y cron jq git apt-transport-https ca-certificates curl gpg software-properties-common

log "Enable kernel module for K8S"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

log "Sysctl configuration for K8S"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

log "Disable swap now and each time at boot"
sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab -

KUBERNETES_VERSION="v1.32"
CRIO_VERSION="v1.32"

log "This is the K8S version: $KUBERNETES_VERSION"
log "This is the CRIO version: $CRIO_VERSION"

log "Add CRI-O repository"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL "https://download.opensuse.org/repositories/isv:/cri-o:/stable:/${CRIO_VERSION}/deb/Release.key" | \
  sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/${CRIO_VERSION}/deb/ /" | \
  sudo tee /etc/apt/sources.list.d/cri-o.list

log "Add Kubernetes repository"
curl -fsSL "https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/deb/Release.key" | \
  sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/deb/ /" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

log "Apt install: CRI-O, kubelet, kubeadm, kubectl"
sudo apt-get update
sudo apt-get install -y cri-o kubelet kubeadm kubectl

log "Elenco delle versioni disponibili di kubeadm (ordinate dalla più recente)..."
sudo apt-cache madison kubeadm | tac

log "Start CRI-O service"
sudo systemctl start crio.service

log "Append KUBELET_EXTRA_ARGS=--node-ip= to kubelet"
#PRIMARY_IP="$(ip --json addr show eth0 | jq -r '.[0].addr_info[] | select(.family == "inet") | .local')"
PRIMARY_IP=$(hostname -I | awk '{print $1}')
log "IP VM: $PRIMARY_IP"
echo "KUBELET_EXTRA_ARGS=--node-ip=$PRIMARY_IP" | sudo tee /etc/default/kubelet
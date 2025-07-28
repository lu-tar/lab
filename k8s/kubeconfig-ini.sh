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

# Percorso del file KUBEADM (può essere ~/.kube/config o custom)
log "Creazione file kubeadm..."
KUBEADM_FILE="kubeadm.config"
CONTROL_NODE_IP="10.0.1.7"


KUBEPROXY_VERSION="v1alpha1"
KUBEADM_VERSION="v1beta4"
KUBELET_VERSION="v1beta1"


# Creazione file vuoto se non esiste
touch kubeadm.config

# Appendi configurazione KUBEADM multilinea
log "Append kubeadm config"
cat <<EOF >> "$KUBEADM_FILE"
apiVersion: kubeadm.k8s.io/$KUBEADM_VERSION
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: $CONTROL_NODE_IP
  bindPort: 6443
nodeRegistration:
  name: "controlplane"

---
apiVersion: kubeadm.k8s.io/$KUBEADM_VERSION
kind: ClusterConfiguration
kubernetesVersion: "v1.32.0"
controlPlaneEndpoint: "$CONTROL_NODE_IP:6443"
apiServer:
  extraArgs:
    - name: "enable-admission-plugins"
      value: "NodeRestriction"
    - name: "audit-log-path"
      value: "/var/log/kubernetes/audit.log"
controllerManager:
  extraArgs:
    - name: "node-cidr-mask-size"
      value: "24"
scheduler:
  extraArgs:
    - name: "leader-elect"
      value: "true"
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
  dnsDomain: "cluster.local"

---
apiVersion: kubelet.config.k8s.io/$KUBELET_VERSION
kind: KubeletConfiguration
cgroupDriver: "systemd"
syncFrequency: "1m"

---
apiVersion: kubeproxy.config.k8s.io/$KUBEPROXY_VERSION
kind: KubeProxyConfiguration
mode: "ipvs"
conntrack:
  maxPerCore: 32768
  min: 131072
  tcpCloseWaitTimeout: "1h"
  tcpEstablishedTimeout: "24h"
EOF

#luca@k8s-control-1:~$ sudo kubeadm init --config=kubeadm.config
# [init] Using Kubernetes version: v1.32.0
# [preflight] Running pre-flight checks
#         [WARNING Hostname]: hostname "controlplane" could not be reached
#         [WARNING Hostname]: hostname "controlplane": lookup controlplane on 10.0.6.1:53: no such host
# error execution phase preflight: [preflight] Some fatal errors occurred:
#
#
# Aggiungere controlplane al dns
#
#
log "Start kubeadm init"
if sudo kubeadm init --config=kubeadm.config; then
  log "✅ kubeadm init completed"
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  kubectl get po -n kube-system
  kubectl get --raw='/readyz?verbose'
else
  echo "❌ kubeadm init failed"
fi
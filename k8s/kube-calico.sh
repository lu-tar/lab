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
# -----------------------------------------
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml -O
#kubectl -n kube-system get pod -l component=kube-controller-manager -o yaml | grep -i cluster-cidr | grep -oP '(?<=--cluster-cidr=)\d+\.\d+\.\d+\.\d+/\d+'
#sed -i 's/^\(\s*cidr:\s*\).*/\110.245.0.0\/16/' installation.yaml

# Estrarre il cluster-cidr dal kube-controller-manager tramite kubectl + grep
NEW_CIDR=$(kubectl -n kube-system get pod -l component=kube-controller-manager -o yaml \
  | grep -i cluster-cidr \
  | grep -oP '(?<=--cluster-cidr=)\d+\.\d+\.\d+\.\d+/\d+' \
  | head -n1)

# Usarlo per sostituire il cidr: in un file YAML via sed
sed -i "s/^\(\s*cidr:\s*\).*/\1${NEW_CIDR//\//\\/}/" installation.yaml

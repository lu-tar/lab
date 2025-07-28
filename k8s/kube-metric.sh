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
kubectl apply -f 
# https://kubernetes-sigs.github.io/metrics-server/
wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability.yaml
luca@k8s-control-1:~/metric-server$ grep -E "tls|4443" components.yaml
#        - --secure-port=4443
#        - --kubelet-insecure-tls
#        - containerPort: 4443
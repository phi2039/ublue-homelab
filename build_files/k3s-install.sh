#!/bin/bash

set -ouex pipefail

# TODO: Configure URLs centrally to handle version changes
K3S_URL=https://github.com/k3s-io/k3s/releases/download/v1.27.10%2Bk3s2/k3s

chmod 644 /etc/rancher/k3s/kubelet.config

dnf5 install -y kubectl k3s-selinux

wget $K3S_URL -O /usr/local/bin/k3s
chmod 755 /usr/local/bin/k3s

#!/usr/bin/sh

set -ouex pipefail

TARGET_PACKAGES=(
    cockpit-ostree
)

dnf5 install --setopt=install_weak_deps=False -y "${TARGET_PACKAGES[@]}"

systemctl enable cockpit.service
systemctl enable podman.socket
systemctl disable zincati.service

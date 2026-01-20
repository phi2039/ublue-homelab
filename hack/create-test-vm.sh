#!/usr/bin/sh

set -e

# Check for sudo/root permissions
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run with sudo or as root"
    exit 1
fi

ISO_SRC=${2:-"$(realpath ./server.iso)"}
VM_NAME=${1:-"homelab-server-test"}

DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"
VCPUS="8"
RAM_MB="32768"
STREAM="stable"
DISK_GB="20"

if [ -f "$DISK_PATH" ]; then
    rm "$DISK_PATH"
fi

ISO_PATH="/var/lib/libvirt/images/homelab-server.iso"
cp "$ISO_SRC" $ISO_PATH

qemu-img create -f qcow2 ${DISK_PATH} "${DISK_GB}G"

virt-install \
  --connect="qemu:///system" \
  --name="${VM_NAME}" \
  --vcpus="${VCPUS}" \
  --memory="${RAM_MB}" \
  --disk="path=${DISK_PATH}" \
  --os-variant="fedora-coreos-$STREAM" \
  --cdrom="${ISO_PATH}" \
  --boot=hd,cdrom \
  --network bridge=k3sbr0 \
  --console pty,target_type=serial
#   --graphics=none
#   --noautoconsole \

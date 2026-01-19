#!/usr/bin/sh

set -ouex pipefail

# Initialize and start Incus
echo "Initializing Incus..."
incus admin init --preseed /etc/incus/preseed.yaml

# Apply changes and restart Incus
echo "Restarting Incus service..."
systemctl daemon-reload
systemctl restart incus

NM_IP=$(nmcli -t -f IP4.ADDRESS dev show enp1s0)
IP_ADDRESS=$(echo $NM_IP | grep -Po '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')
echo "Installation complete"
echo "Access Incus WebUI at: https://$IP_ADDRESS:8443"

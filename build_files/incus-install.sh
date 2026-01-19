#!/usr/bin/sh

set -ouex pipefail

# TODO: Configure URLs centrally to handle version changes
INCUS_UI_URL=https://pkgs.zabbly.com/incus/stable/pool/main/i/incus/incus-ui-canonical_6.20-debian13-202601150536_amd64.deb

# Incus preseed configuration for automatic initialization
echo "Installing base Incus application..."
chmod 644 /etc/incus/preseed.yaml

# Configure sysctl settings for Incus
chmod 644 /etc/sysctl.d/99-incus.conf

#Install Incus and dependencies
dnf5 install -y incus incus-tools lxc dpkg

# Update subuid/subgid
bash -c 'echo "root:1000000:1000000000" >> /etc/subuid'
bash -c 'echo "root:1000000:1000000000" >> /etc/subgid'

# Install WebUI
echo "Installing Incus WebUI..."
wget $INCUS_UI_URL
dpkg -x $(basename "$INCUS_UI_URL") ./incus-ui/
rsync -vaH incus-ui/opt/incus/. /opt/incus/

systemctl enable incus.service
systemctl enable incus-workaround.service

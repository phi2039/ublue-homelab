#!/usr/bin/sh

set -ouex pipefail

# TODO: Configure URLs centrally to handle version changes
INCUS_UI_URL=https://pkgs.zabbly.com/incus/stable/pool/main/i/incus/incus-ui-canonical_6.20-debian13-202601150536_amd64.deb

# Incus preseed configuration for automatic initialization
echo "Installing base Incus application..."

# Install Incus and dependencies
dnf5 install -y incus incus-tools lxc dpkg

# Install WebUI
echo "Installing Incus WebUI..."
wget $INCUS_UI_URL
INCUS_PKG=$(basename "$INCUS_UI_URL")
dpkg -x $INCUS_PKG ./incus-ui/
# rsync -vaH incus-ui/opt/incus/. /var/opt/incus/ # /opt is symlinked to /var/opt
mkdir -p /usr/lib/opt/incus/
mv incus-ui/opt/incus/ui /usr/lib/opt/incus/ui
rm -rf $INCUS_PKG incus-ui/

systemctl enable incus.service
systemctl enable incus-workaround.service
systemctl enable incus-init.service

#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y sway-config-fedora sway-systemd qt5-qtwayland qt5-qtbase-gui qt6-qtwayland qt6-qtbase-gui foot libnotify rofi-wayland xdg-user-dirs
dnf5 install -y firefox network-manager-applet networkmanager light imv swaylock waybar rofi dunst kanshi thunar

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
dnf5 -y copr enable bieszczaders/kernel-cachyos-lto
dnf5 -y install kernel-cachyos-lto kernel-cachyos-lto-devel-matched
setsebool -P domain_kernel_load_modules on
dnf5 -y install libdnf5-plugin-actions
mkdir -p /etc/dnf/libdnf5-plugins/actions.d
tee /etc/dnf/libdnf5-plugins/actions.d/cachy-default.actions << 'EOF'
# After installing any kernel* package, set the latest CachyOS kernel as the default boot entry
post_transaction:kernel*:in::/usr/bin/sh -c /usr/bin/grubby\ --set-default=/boot/$(ls\ /boot\ |\ grep\ vmlinuz.*cachy\ |\ sort\ -V\ |\ tail\ -1)
EOF
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y swap zram-generator-defaults cachyos-settings
dracut -f
dnf5 -y install scx-scheds scx-tools
dnf5 -y install scx-manager
dnf5 -y install ananicy-cpp
systemctl enable ananicy-cpp

#### Example for enabling a System Unit File

systemctl enable podman.socket

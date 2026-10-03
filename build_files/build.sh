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
dnf5 install -y toolbox podman buildah flatpak rpm-ostree ostree
dnf5 install -y @cosmic-desktop-environment
dnf5 install -y dnf-plugins-core
dnf5 -y config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf5 install -y brave-origin
dnf5 install -y fastfetch

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y install scx-scheds scx-tools
dnf5 -y swap zram-generator-defaults cachyos-settings
dnf5 -y install ananicy-cpp
dnf5 -y autoremove

#### Example for enabling a System Unit File

systemctl enable podman
systemctl enable ananicy-cpp
systemctl enable cosmic-greeter
systemctl enable cpupower
systemctl enable scx_loader

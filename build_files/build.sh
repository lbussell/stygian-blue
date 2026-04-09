#!/bin/bash

set -ouex pipefail

## Install packages
# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1
# This installs a package from fedora repos:
# dnf5 install -y tmux

## Install Microsoft Edge
rpm --import https://packages.microsoft.com/keys/microsoft.asc
curl -fsSL -o /etc/yum.repos.d/microsoft-edge.repo \
    https://packages.microsoft.com/yumrepos/edge/config.repo
sed -i 's/gpgcheck=0/gpgcheck=1/' /etc/yum.repos.d/microsoft-edge.repo
sed -i 's/repo_gpgcheck=0/repo_gpgcheck=1/' /etc/yum.repos.d/microsoft-edge.repo
dnf5 install -y microsoft-edge-stable
rm -f /etc/yum.repos.d/microsoft-edge.repo

## Install 1Password
rpm --import https://downloads.1password.com/linux/keys/1password.asc
cat > /etc/yum.repos.d/1password.repo << 'EOF'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF
dnf5 install -y 1password
rm -f /etc/yum.repos.d/1password.repo

## Custom ujust commands
cp /ctx/stygian-blue.just /usr/share/ublue-os/just/60-custom.just

# Use a COPR Example:
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Example for enabling a System Unit File
# systemctl enable podman.socket

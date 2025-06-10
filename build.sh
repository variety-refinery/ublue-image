#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

curl --location --output /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
curl --location --output /etc/yum.repos.d/scrcpy.repo https://copr.fedorainfracloud.org/coprs/zeno/scrcpy/repo/fedora-41/zeno-scrcpy-fedora-41.repo
curl --location --output /tmp/opensnitch.rpm https://github.com/evilsocket/opensnitch/releases/download/v1.6.6/opensnitch-1.6.6-1.x86_64.rpm
curl --location --output /tmp/opensnitch-ui.rpm https://github.com/evilsocket/opensnitch/releases/download/v1.6.6/opensnitch-ui-1.6.6-1.noarch.rpm

dnf5 remove --assumeyes tuned tuned-ppd

dnf5 install --assumeyes \
	/tmp/opensnitch-ui.rpm \
	/tmp/opensnitch.rpm \
	/tmp/packages/*.rpm \
	adw-gtk3-theme \
	akregator \
	alsa-lib-devel \
	argon2 \
	bat \
	bees \
	borgbackup \
	chafa \
	clang \
	cmake \
	comrak \
	cryfs \
	dotnet-runtime-9.0 \
	dotnet-sdk-9.0 \
	easyeffects \
	fastfetch \
	fd-find \
	fish \
	flatpak-builder \
	graphviz \
	gstreamer1-devel \
	gstreamer1-plugins-bad-free \
	gstreamer1-plugins-bad-free-devel \
	gstreamer1-plugins-bad-free-extras \
	gstreamer1-plugins-base-devel \
	gstreamer1-plugins-base-tools \
	gstreamer1-plugins-good \
	gstreamer1-plugins-good-extras \
	gstreamer1-plugins-ugly \
	gtk3-devel \
	hyfetch \
	inxi \
	kcolorchooser \
	khal \
	kleopatra \
	krita \
	libavif-tools \
	libcurl-devel \
	libgit2-devel \
	libssh2-devel \
	mesa-demos \
	mpd \
	mpdris2 \
	mpv \
	ncmpcpp \
	neovim \
	ninja-build \
	nmap \
	nmap-ncat \
	openssl-devel \
	oxipng \
	p7zip \
	php \
	php-pgsql \
	pkgconf \
	plasma-sdk \
	pnpm \
	postgresql \
	postgresql-contrib \
	postgresql-server \
	powertop \
	qalculate \
	qalculate-gtk \
	qt6-qdbusviewer \
	rclone \
	rpm-build \
	rpm-devel \
	rpmdevtools \
	rpmlint \
	rustup \
	scrcpy \
	skanpage \
	speech-dispatcher \
	sqlitebrowser \
	tailscale \
	tealdeer \
	tlp \
	tlp-rdw \
	tmux \
	trash-cli \
	vdirsyncer \
	xdotool \
	ydotool \
	yq 
	yt-dlp

cat << EOF > /etc/modprobe.d/v4l2loopback.conf
options v4l2loopback video_nr=8 exclusive_caps=1
EOF

cat << EOF > /etc/tlp.d/00-autosuspend.conf
USB_DENYLIST="04e8:6860"
EOF

cat << EOF > /etc/sysctl.d/99-sysrq.conf
kernel.sysrq = 244
EOF

cat << EOF > /etc/bees/beesd.conf
## Config for Bees: /etc/bees/beesd.conf.sample
## https://github.com/Zygo/bees
## It's a default values, change it, if needed

# How to use?
# Copy this file to a new file name and adjust the UUID below

# Which FS will be used
UUID=1fa8bc05-0ffc-425b-b4d9-a8f15b3d492d

## System Vars
# Change carefully
# WORK_DIR=/run/bees/
# MNT_DIR="\$WORK_DIR/mnt/\$UUID"
# BEESHOME="\$MNT_DIR/.beeshome"
# BEESSTATUS="\$WORK_DIR/\$UUID.status"

## Options to apply, see `beesd --help` for details
OPTIONS="--loadavg-target 8"

## Bees DB size
# Hash Table Sizing
# sHash table entries are 16 bytes each
# (64-bit hash, 52-bit block number, and some metadata bits)
# Each entry represents a minimum of 4K on disk.
# unique data size    hash table size    average dedupe block size
#     1TB                 4GB                  4K
#     1TB                 1GB                 16K
#     1TB               256MB                 64K
#     1TB                16MB               1024K
#    64TB                 1GB               1024K
#
# Size MUST be multiple of 128KB
# DB_SIZE=\$((1024*1024*1024)) # 1G in bytes
EOF

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable tailscaled.service
systemctl enable opensnitch.service
systemctl enable tlp.service
systemctl enable beesd@1fa8bc05-0ffc-425b-b4d9-a8f15b3d492d.service
systemctl enable ydotool.service

systemctl mask systemd-rfkill.service systemd-rfkill.socket


#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

curl --location --output /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
curl --location --output /etc/yum.repos.d/starship.repo https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-40/atim-starship-fedora-40.repo
curl --location --output /etc/yum.repos.d/micro-packages.repo https://copr.fedorainfracloud.org/coprs/niko-micro/micro-packages/repo/fedora-40/niko-micro-micro-packages-fedora-40.repo
curl --location --output /etc/yum.repos.d/bat-extra.repo https://copr.fedorainfracloud.org/coprs/awood/bat-extras/repo/fedora-40/awood-bat-extras-fedora-40.repo

# TODO: package and add todoman, bat-extras, (new) micro-systemd-units, htmlq, prettier, create-todo-user, topgrade, (new) micro-manager
rpm-ostree install \
	adw-gtk3-theme \
	akregator \
	bat \
	chafa \
	cryfs \
	easyeffects \
	eza \
	fastfetch \
	fish \
	graphviz \
	hyfetch \
	inxi \
	khal \
	kleopatra \
	krita \
	merkuro \
	mpd \
	mpdris2 \
	mpv \
	ncmpcpp \
	neovim \
	nextcloud-client \
	nmap-ncat \
	oxipng \
	p7zip \
	pnpm \
	qalculate-gtk \
	reader \
	rpm-build \
	rpm-devel \
	rpmdevtools \
	rpmlint \
	rustup \
	skanpage \
	speech-dispatcher \
	starship \
	stopmpd \
	string_reminder \
	tailscale \
	tealdeer \
	trash-cli \
	vdirsyncer \
	wine \
	yq \
	yt-dlp

# this installs a package from fedora repos
#rpm-ostree install screen

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable tailscaled.service

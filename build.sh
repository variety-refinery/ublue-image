#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

curl --location --output /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

# TODO: package and add todoman, reader, string-reminder, bat-extras, (new) micro-systemd-units, htmlq, prettier, stopmpd, topgrade, create-todo-user
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
	mpv \
	neovim \
	nextcloud-client \
	oxipng \
	p7zip \
	pnpm \
	qalculate-gtk \
	rustup \
	skanpage \
	speech-dispatcher \
	starship \
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

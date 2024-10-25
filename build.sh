#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | tee -a /etc/yum.repos.d/vscodium.repo

curl --location --output /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
curl --location --output /etc/yum.repos.d/starship.repo https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-40/atim-starship-fedora-40.repo
curl --location --output /etc/yum.repos.d/micro-packages.repo https://copr.fedorainfracloud.org/coprs/niko-micro/micro-packages/repo/fedora-40/niko-micro-micro-packages-fedora-40.repo
curl --location --output /etc/yum.repos.d/bat-extra.repo https://copr.fedorainfracloud.org/coprs/awood/bat-extras/repo/fedora-40/awood-bat-extras-fedora-40.repo
curl --location --output /etc/yum.repos.d/scrcpy.repo https://copr.fedorainfracloud.org/coprs/niko-micro/micro-packages/repo/fedora-40/niko-micro-micro-packages-fedora-40.repo

curl --location --output /tmp/opensnitch.rpm https://github.com/evilsocket/opensnitch/releases/download/v1.6.6/opensnitch-1.6.6-1.x86_64.rpm
curl --location --output /tmp/opensnitch-ui.rpm https://github.com/evilsocket/opensnitch/releases/download/v1.6.6/opensnitch-ui-1.6.6-1.noarch.rpm

rpm-ostree install \
	/tmp/krender.rpm \
	/tmp/npkg.rpm \
	/tmp/opensnitch-ui.rpm \
	/tmp/opensnitch.rpm \
	/tmp/typewriter.rpm \
	adw-gtk3-theme \
	akregator \
	bat \
	borgbackup \
	chafa \
	clang \
	cmake \
	codium \
	comrak \
	cryfs \
	easyeffects \
	epson-inkjet-printer-escpr \
	eza \
	fastfetch \
	fd-find \
	fish \
	graphviz \
	gtk3-devel \
	hyfetch \
	inxi \
	kcolorchooser \
	khal \
	kleopatra \
	krita \
	libavif-tools \
	meow \
	merkuro \
	mesa-demos \
	mpd \
	mpdris2 \
	mpv \
	ncmpcpp \
	neovim \
	nextcloud-client \
	ninja-build \
	nmap-ncat \
	oxipng \
	p7zip \
	pnpm \
	qalculate-gtk \
	qt6-qdbusviewer \
	reader \
	rpm-build \
	rpm-devel \
	rpmdevtools \
	rpmlint \
	rustup \
	scrcpy \
	skanpage \
	speech-dispatcher \
	sqlitebrowser \
	starship \
	stopmpd \
	string_reminder \
	tailscale \
	tealdeer \
	trash-cli \
	v4l2loopback \
	vdirsyncer \
	yq \
	yt-dlp

# this installs a package from fedora repos
#rpm-ostree install screen

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable tailscaled.service
systemctl enable opensnitch.service

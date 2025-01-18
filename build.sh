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
curl --location --output /etc/yum.repos.d/scrcpy.repo https://copr.fedorainfracloud.org/coprs/zeno/scrcpy/repo/fedora-40/zeno-scrcpy-fedora-40.repo
curl --location --output /tmp/opensnitch.rpm https://github.com/evilsocket/opensnitch/releases/download/v1.6.6/opensnitch-1.6.6-1.x86_64.rpm
curl --location --output /tmp/opensnitch-ui.rpm https://github.com/evilsocket/opensnitch/releases/download/v1.6.6/opensnitch-ui-1.6.6-1.noarch.rpm
curl --location --output /tmp/sunshine.rpm https://github.com/LizardByte/Sunshine/releases/download/v0.23.1/sunshine-fedora-39-amd64.rpm

rpm-ostree override remove \
	tuned tuned-ppd

rpm-ostree install \
	/tmp/akmods-rpms/kmods/*v4l2loopback*.rpm \
	/tmp/opensnitch-ui.rpm \
	/tmp/opensnitch.rpm \
	/tmp/packages/*.rpm \
	/tmp/sunshine.rpm \
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
	java-1.8.0-openjdk \
	kcolorchooser \
	khal \
	kleopatra \
	krita \
	libavif-tools \
	libcurl-devel \
	libgit2-devel \
	libssh2-devel \
	merkuro \
	mesa-demos \
	mpd \
	mpdris2 \
	mpv \
	ncmpcpp \
	neovim \
	nextcloud-client \
	ninja-build \
	nmap \
	nmap-ncat \
	openssl-devel \
	oxipng \
	p7zip \
	php \
	php-pgsql \
	pkgconf \
	pnpm \
	postgresql \
	postgresql-server \
	powertop \
	qalculate \
	qalculate-gtk \
	qt6-qdbusviewer \
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
	yq \
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

# this installs a package from fedora repos
#rpm-ostree install screen

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable tailscaled.service
systemctl enable opensnitch.service
systemctl enable tlp.service

systemctl mask systemd-rfkill.service systemd-rfkill.socket

#FROM ghcr.io/ublue-os/kinoite-main:latest
FROM ghcr.io/ublue-os/kinoite-main:42

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:stable
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN mkdir -p /var/lib/alternatives && \
    dnf5 install --assumeyes \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    ostree container commit

COPY build.sh /tmp/build.sh
ADD packages /tmp/packages
ADD zoom /tmp/zoom

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit


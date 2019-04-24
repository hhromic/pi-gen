#!/bin/bash -e

# Configure apt so that it does not install additional packages
# Source: https://wiki.debian.org/ReduceDebian
install -m 644 extra_files/80noadditional "${ROOTFS_DIR}"/etc/apt/apt.conf.d/80noadditional

# Configure apt so that it does not download package lists periodically
# Source: https://wiki.debian.org/UnattendedUpgrades
install -m 644 extra_files/81noperiodic "${ROOTFS_DIR}"/etc/apt/apt.conf.d/81noperiodic

# Configure dpkg so that it does not install documentation nor locales in packages
# Source: https://askubuntu.com/a/401144
install -m 644 extra_files/nodoc "${ROOTFS_DIR}"/etc/dpkg/dpkg.cfg.d/nodoc
install -m 644 extra_files/nolocale "${ROOTFS_DIR}"/etc/dpkg/dpkg.cfg.d/nolocale

# Remove documentation and locales from already installed packages
# Source: https://askubuntu.com/a/401144
find "${ROOTFS_DIR}"/usr/share/doc ! -name copyright \( -type f -o -type l \) -delete
find "${ROOTFS_DIR}"/usr/share/doc -empty -delete
rm -rf "${ROOTFS_DIR}"/usr/share/{groff,info,linda,lintian,locale,man}/*
rm -rf "${ROOTFS_DIR}"/var/cache/man/*

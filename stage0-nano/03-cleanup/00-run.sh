#!/bin/bash -e

on_chroot <<"__EOF__"
# Mark all libraries as autoinstalled, so they are autoremoved when no longer required
dpkg-query -Wf '${binary:Package}\n' 'lib*[!raspberrypi-bin]' | xargs apt-mark auto

# Remove non-critical packages
apt-get purge -y \
    gcc-4.6-base gcc-4.7-base gcc-4.8-base gcc-4.9-base gcc-5-base \
    plymouth

# Remove all packages that were automatically installed and are no longer required
apt-get autoremove --purge -y
__EOF__

#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
	bootstrap --variant minbase stretch "${ROOTFS_DIR}" http://raspbian.raspberrypi.org/raspbian/
fi

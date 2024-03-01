#!/bin/bash

# Still need to build libpng and libz for deutex because they are not included by default in the sepp-ci container
docker run --user $(id -u):$(id -g) \
-v "$(pwd)":/opssat-doom:rw \
-it \
sepp-ci:latest \
bash -c 'source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi && \
ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3 && \
ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libm.so.6 /lib/libm.so.6 && \
ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libc.so.6 /lib/libc.so.6 && \
ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/usr/lib/libstdc++.so.6 /lib/libstdc++.so.6 && \
ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libgcc_s.so.1 /lib/libgcc_s.so.1 && \
ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libpng16.so.16 /lib/libpng16.so.16 && \
ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libz.so.1 /lib/libz.so.1 && \
cd opssat-doom && \
./build-deutex-32-deps.sh && \
./run-32.sh --use-qemu'

# FIXME: replace sky doesn't work in this script, it just hangs.
# This line is placed right before "./run-32.sh --use-qemu"
# ./replace-sky.sh /opssat-doom/sample.jpeg --use-qemu && \
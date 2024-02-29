#!/bin/bash

# Build and run DOOM!
docker run --user $(id -u):$(id -g) \
-v "$(pwd)":/opssat-doom:rw \
-it \
sepp-ci:latest \
bash -c 'source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi && \
cd /opssat-doom && \
./init-repo.sh && \
./build-all-32.sh && \
./run-32.sh --use-qemu'

# FIXME: replace sky doesn't work in this script, it just hangs.
# This line is placed right before "./run-32.sh --use-qemu"
# ./replace-sky.sh /opssat-doom/sample.jpeg --use-qemu && \#
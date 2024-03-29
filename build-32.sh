#!/bin/bash

# source the Yocto Project environment setup script to prepare for cross-compilation
source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi

# default values
STATIC_FLAG=NO
CLEAN_FLAG=NO

# delete backup folder if it exists because it contains the old build
rm -rf backup

# parse arguments
for arg in "$@"
do
  if [[ "$arg" == "static" ]]; then
    STATIC_FLAG=YES
  elif [[ "$arg" == "clean" ]]; then
    CLEAN_FLAG=YES
  fi
done

# change directory to src
pushd src

# clean if requested
if [[ "$CLEAN_FLAG" == "YES" ]]; then
  make clean
fi

# build the project
make STATIC=$STATIC_FLAG

# Return to the original directory
popd

# Create symlinks
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libm.so.6 /lib/libm.so.6
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libc.so.6 /lib/libc.so.6

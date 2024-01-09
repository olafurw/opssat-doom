#!/bin/bash

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

# source the environment setup script
source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi

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


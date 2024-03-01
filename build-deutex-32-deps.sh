#!/bin/bash

# Define lib versions
LIBPNG_VERSION=1.6.16
ZLIB_VERSION=1.2.13

# Source the Yocto Project environment setup script to prepare for cross-compilation
source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi

##########
# libpng #
##########

# Set the URL to download libpng from SourceForge
LIBPNG_URL="https://master.dl.sourceforge.net/project/libpng/libpng16/older-releases/${LIBPNG_VERSION}/libpng-${LIBPNG_VERSION}.tar.gz"

# Create a directory to hold the libpng source files
mkdir -p /opssat-doom/libpng-source

# Change directory to the libpng source directory
cd /opssat-doom/libpng-source

# Output a message indicating the start of the libpng download
echo "Downloading libpng-${LIBPNG_VERSION}..."

# Download libpng using wget
wget --no-check-certificate ${LIBPNG_URL}

# Extract the downloaded tar.gz file
tar -xzf libpng-${LIBPNG_VERSION}.tar.gz

# Change directory to the extracted libpng source directory
cd libpng-${LIBPNG_VERSION}

# Configure the libpng build for the target architecture and specify the installation directory
./configure --host=arm-poky-linux-gnueabi --prefix=/home/user/poky_sdk/tmp/sysroots/beaglebone

# Clean previous compile, if any
make clean

# Compile libpng
make

# Install libpng to the specified prefix directory
make install

# Create the symlink
ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libpng16.so.16 /lib/libpng16.so.16

# Clean up the libpng source directory to free up space
rm -rf /opssat-doom/libpng-source

########
# libz #
########

# Define download URL for zlib from GitHub
ZLIB_URL="https://github.com/madler/zlib/archive/refs/tags/v${ZLIB_VERSION}.tar.gz"

# Create a directory to hold the zlib source files
mkdir -p /opssat-doom/zlib-source

# Change directory to the zlib source directory
cd /opssat-doom/zlib-source

# Output a message indicating the start of the zlib download
echo "Downloading zlib-${ZLIB_VERSION}..."

# Download zlib using wget
wget ${ZLIB_URL}

# Extract the downloaded tar.gz file
tar -xzf v${ZLIB_VERSION}.tar.gz

# Change directory to the extracted zlib source directory
cd zlib-${ZLIB_VERSION}

# Configure the zlib build for the target architecture
./configure --prefix=/home/user/poky_sdk/tmp/sysroots/beaglebone

# Clean previous compile, if any
make clean

# Compile zlib
make

# Install zlib to the specified prefix directory
make install

# Create the symlink
ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libz.so.1 /lib/libz.so.1

# Clean up the zlib source directory to free up space
rm -rf /opssat-doom/zlib-source

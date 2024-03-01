set -e;

# Source the Yocto Project environment setup script to prepare for cross-compilation
source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi

# Build deutex
./build-deutex-32.sh;

# Build image resampler
pushd playpal-image-resample;
./build-32.sh clean;
popd;

# Build DOOM!
./build-32.sh clean;
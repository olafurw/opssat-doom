# source the Yocto Project environment setup script to prepare for cross-compilation
source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi

# build deutex dependencies: libn png and libz
./build-deutex-32-deps.sh

pushd deutex;
make clean
./bootstrap;
./configure --host=arm-poky-linux-gnueabi
make;
popd;

# create the symlinks
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libm.so.6 /lib/libm.so.6
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libc.so.6 /lib/libc.so.6
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libpng16.so.16 /lib/libpng16.so.16
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libz.so.1 /lib/libz.so.1
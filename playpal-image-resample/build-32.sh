# source the Yocto Project environment setup script to prepare for cross-compilation
source /home/user/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi

# compile
$CXX resize.cpp playpal.cpp resample.cpp main.cpp -Wall -std=c++14 -O3 -o resample

# create the symlinks
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/usr/lib/libstdc++.so.6 /lib/libstdc++.so.6
sudo ln -s -f /home/user/poky_sdk/tmp/sysroots/beaglebone/lib/libgcc_s.so.1 /lib/libgcc_s.so.1

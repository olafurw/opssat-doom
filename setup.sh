export LANGUAGE=C;
export LC_CTYPE=C;
export LC_ALL=C;

# Setup the poky env (and possible other env settings)
source ~/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi;
export PKG_CONFIG_PATH=/home/user/poky_sdk/tmp/sysroots/beaglebone/lib/pkgconfig:$PKG_CONFIG_PATH;
sudo apt-get install -y automake autoconf libtool make;

# SDL 1.2
git clone https://github.com/libsdl-org/SDL-1.2.git
pushd SDL-1.2
./autogen.sh
./configure --prefix=/home/user/poky_sdk/tmp/sysroots/beaglebone --host=arm-unknown-linux-gnueabi --target=arm-unknown-linux-gnueabi --build=i686-pc-linux
make
make install
popd;

# SDL_mixer
git clone --branch SDL-1.2 https://github.com/libsdl-org/SDL_mixer.git
pushd SDL_mixer
./autogen.sh
SDL_CFLAGS="-I/home/user/poky_sdk/tmp/sysroots/beaglebone/include/SDL" ./configure --prefix=/home/user/poky_sdk/tmp/sysroots/beaglebone --host=arm-unknown-linux-gnueabi --target=arm-unknown-linux-gnueabi --build=i686-pc-linux
make
make install
popd;

# SDL_net
git clone --branch SDL-1.2 https://github.com/libsdl-org/SDL_net.git;
pushd SDL_net;
./autogen.sh;
SDL_CFLAGS="-I/home/user/poky_sdk/tmp/sysroots/beaglebone/include/SDL" ./configure --prefix=/home/user/poky_sdk/tmp/sysroots/beaglebone --host=arm-unknown-linux-gnueabi --target=arm-unknown-linux-gnueabi --build=i686-pc-linux;
make;
make install;
popd;

if [ -f "~/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi" ]; then
    # Set and required flags and configure the target params
    export SDL_LIBS="-lSDL"
    export SDL_CFLAGS="-I/home/user/poky_sdk/tmp/sysroots/beaglebone/include/SDL/"
    ./autogen.sh --host=arm-unknown-linux-gnueabi --target=arm-unknown-linux-gnueabi --build=i686-pc-linux
else
    ./autogen.sh
fi

# Build
make;
export LANGUAGE=C;
export LC_CTYPE=C;
export LC_ALL=C;

POKY_ENV=~/poky_sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi

# Setup the poky env (and possible other env settings)
if [ -f "$POKY_ENV" ]; then
    source $POKY_ENV;
    #sudo dpkg --add-architecture i386;
    #sudo apt update;
    #export LD_LIBRARY_PATH=~/poky_sdk/tmp/sysroots/beaglebone/lib/
fi

# Install the packages needed
sudo apt-get install -y gcc make libsdl1.2-dev libsdl-net1.2-dev libsdl-mixer1.2-dev libtool automake autoconf;

# Set and required flags and configure the target params
if [ -f "$POKY_ENV" ]; then
    export SDL_LIBS=$(pkg-config --libs sdl)
    export SDL_CFLAGS=$(pkg-config --cflags sdl)
    ./autogen.sh --build=arm --host=x86 --target=arm
else
    ./autogen.sh
fi

# Build
make;
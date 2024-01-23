if [ $# -lt 1 ]; then
  echo 1>&2 "error: missing argument";
  echo 1>&2 "$0 <image>";
  exit 1
fi

if [ ! -f "$1" ]; then
    echo 1>&2 "error: file '$1' not found";
    echo 1>&2 "$0 <image>";
    exit 1
fi

# Init repo
git submodule init;
git submodule update;
sudo apt install -y pkg-config;

# Remove old files
rm -rf extract/;
rm demos/doom-earth.wad;

# Build resizer
pushd image-resizer-bmp;
make;
popd;

# Build deutex
pushd deutex;
./bootstrap;
./configure
make;
popd;

# Extract the data from the wad
mkdir extract;
pushd extract;
../deutex/src/deutex -doom ../demos/ -xtract;
popd;

# Resize the image
./image-resizer-bmp/resize -i "$1" -x 256 -y 128 -c 3 -o extract/patches/sky1.bmp;

# Rebuild the wad
pushd extract;
../deutex/src/deutex -doom ../demos/ -iwad -make ../demos/doom-earth.wad;
popd;

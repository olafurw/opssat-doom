# Init repo
git submodule init;
git submodule update;

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

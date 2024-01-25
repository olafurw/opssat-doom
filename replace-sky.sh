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

# Extract the wad
./wad-extract.sh;

# kmeans reduce the image
pushd kmeans-reduce;
./extract-pixels.sh "$1";
popd;

# Create a new playpal file
pushd playpal-test;
./run.sh;
popd;

# Resize the image
./image-resizer-bmp/resize -i kmeans.bmp -x 256 -y 128 -c 3 -o extract/patches/sky1.bmp;

# Rebuild the wad
./wad-pack.sh;

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
./init-repo.sh;

# Build resizer
pushd image-resizer-bmp;
./build.sh;
popd;

# Build deutex
./build-deutex.sh;

./wad-extract.sh;

# Resize the image
./image-resizer-bmp/resize -i "$1" -x 256 -y 128 -c 3 -o extract/patches/sky1.bmp;

# Rebuild the wad
./wad-pack.sh;

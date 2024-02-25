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

# reduce the image to 256 colors and generate a new playpal from it
pushd playpal-image-resample;
./resample ../"$1" && cp playpal.lmp ../extract/lumps/playpal.lmp && cp sky1.bmp ../extract/patches/sky1.bmp;
popd;

# Rebuild the wad
./wad-pack.sh;

#!/bin/sh

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

USE_QEMU=$2
if [ "$USE_QEMU" = "--use-qemu" ]; then
    QEMU_CMD_PREFIX="qemu-arm"
else
    QEMU_CMD_PREFIX=""
fi

# Extract the wad
./wad-extract.sh $USE_QEMU;

# Save the current directory path
rs_dir=$(pwd)

# Change to the new directory
cd playpal-image-resample || exit 1

# Reduce the image to 256 colors and generate a new playpal from it
# FIXME: doesn't work when running with docker from the host machine, it just hangs
$QEMU_CMD_PREFIX ./resample $1 && cp playpal.lmp ../extract/lumps/playpal.lmp && cp sky1.bmp ../extract/patches/sky1.bmp;

# Return to the original directory
cd "$rs_dir" || exit 1

# Rebuild the wad
./wad-pack.sh $USE_QEMU;

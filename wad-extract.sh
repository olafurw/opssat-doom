#!/bin/sh

USE_QEMU=$1
if [ "$USE_QEMU" = "--use-qemu" ]; then
    QEMU_CMD_PREFIX="qemu-arm"
else
    QEMU_CMD_PREFIX=""
fi

# Remove old files
rm -rf extract/

# Extract the data from the wad
mkdir extract

# Save the current directory path
we_dir=$(pwd)

# Change to the new directory
cd extract || exit 1

# Perform the desired operation in the new directory
$QEMU_CMD_PREFIX ../deutex/src/deutex -doom ../demos/ -bmp -xtract

# Return to the original directory
cd "$we_dir" || exit 1

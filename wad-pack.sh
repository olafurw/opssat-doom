#!/bin/sh

USE_QEMU=$1
if [ "$USE_QEMU" = "--use-qemu" ]; then
    QEMU_CMD_PREFIX="qemu-arm"
else
    QEMU_CMD_PREFIX=""
fi

# Remove the specified file
rm demos/doom-earth.wad

# Save the current directory path
wp_dir=$(pwd)

# Change to the 'extract' directory
cd extract || exit 1

# Perform the operation with deutex to create the IWAD
$QEMU_CMD_PREFIX ../deutex/src/deutex -doom ../demos/ -iwad -make ../demos/doom-earth.wad

# Return to the original directory
cd "$wp_dir" || exit 1

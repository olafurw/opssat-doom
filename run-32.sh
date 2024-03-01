#!/bin/sh

# Usage of qemu-arm is optional and controlled by the first script argument
# If the first argument is "--use-qemu", then QEMU will be used
USE_QEMU=$1
if [ "$USE_QEMU" = "--use-qemu" ]; then
    CMD_PREFIX="qemu-arm"
else
    CMD_PREFIX=""
fi

# The demos
demos_folder="demos/rng-0"
demos_shareware="georges-e1m2 georges-e1m2b zero-e1m1 zero-e1m2 zero-e1m3 zero-e1m4 zero-e1m5 zero-e1m6 zero-e1m7"

# Create toGround directory (if it doesn't exist already)
toGround_dir="toGround"
mkdir -p $toGround_dir;

# Create a new subdirectory with the current timestamp
timestamp=$(date +"%Y%m%d%H%M%S")
ts_toGround_dir=$toGround_dir/$timestamp
mkdir -p $ts_toGround_dir

# Play through all the demos
runid=1
for demo in $demos_shareware
do
    # The name of this demo's stats file
    statdump_filepath=$toGround_dir/stats-$demo.txt

    # Run DOOM!
    $CMD_PREFIX src/bin/opssat-doom -nosound -nomusic -nosfx -runid $runid -longtics -iwad demos/doom-earth.wad -cdemo $demos_folder/$demo -statdump ${statdump_filepath} >> $toGround_dir/doom.log 2>&1;
    if [ -f "${statdump_filepath}" ]; then
        if diff ${statdump_filepath} ${demos_folder}/${demo}.txt; then
            result="OK"
        else
            result="ERROR"
            diff ${statdump_filepath} ${demos_folder}/${demo}.txt >> $toGround_dir/doom.log 2>&1
        fi
        echo ${result} - ${demo} >> $toGround_dir/results.log 2>&1;
    fi

    runid=$((runid+1))
done

# Move all files and folders from the base directory to the new timestamped directory
# This excludes any directories that match the timestamp pattern and the new directory itself
for item in $toGround_dir/*; do
    # Extract the basename of the item
    item_name=$(basename "$item")
    
    # Check if the item is a directory and matches the timestamp pattern
    if [ -d "$item" ]; then
        case "$item_name" in
            [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
                # It's a directory with a name that matches the timestamp pattern, so skip it
                continue
                ;;
        esac
    fi
    
    # It's either a file or a directory that doesn't match the timestamp pattern, so move it
    if [ "$item" != "$ts_toGround_dir" ]; then # Also ensure not to move the new directory into itself
        mv "$item" "$ts_toGround_dir"
    fi
done
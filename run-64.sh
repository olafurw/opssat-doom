#!/bin/bash

demos_folder="demos/rng-0"
demos_shareware="e1m1"

for demo in $demos_shareware
do
    ./src/bin/opssat-doom -nosound -nomusic -nosfx -runid 1 -iwad demos/doom.wad -cdemo $demos_folder/$demo -statdump toGround/run_diff.txt;
    echo $demo;
done
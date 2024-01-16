#!/bin/bash

demos_folder="demos/rng-0"
demos_shareware="e1m1 e1m2 e1m3 e1m4 e1m5 e1m6 e1m7"

for demo in $demos_shareware
do
    ./src/bin/opssat-doom -nosound -nomusic -nosfx -runid 1 -iwad demos/doom.wad -cdemo $demos_folder/$demo -statdump toGround/run_diff.txt;
    echo $demo;
done
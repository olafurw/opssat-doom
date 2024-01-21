#!/bin/bash

demos_folder="demos/rng-0"
demos_shareware="zero-e1m1 zero-e1m2 zero-e1m3 zero-e1m4 zero-e1m5 zero-e1m6 zero-e1m7"

for demo in $demos_shareware
do
    ./src/bin/opssat-doom -nosound -nomusic -nosfx -nodraw -runid 3 -iwad demos/doom.wad -cdemo $demos_folder/$demo;
    echo $demo;
done
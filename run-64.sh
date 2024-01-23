#!/bin/bash

demos_folder="demos/rng-0"
demos_shareware="zero-e1m1 zero-e1m2 zero-e1m3 zero-e1m4 zero-e1m5 zero-e1m6 zero-e1m7"

statdump_filepath=toGround/run-64.txt

for demo in $demos_shareware
do
    ./src/bin/opssat-doom -nosound -nomusic -nosfx -nodraw -runid 1 -longtics -iwad demos/doom.wad -cdemo $demos_folder/$demo -statdump toGround/run-64.txt >> toGround/doom.log 2>&1;
    if [ -f "${statdump_filepath}" ]; then
        if diff ${statdump_filepath} ${demos_folder}/${demo}.txt; then
            result="OK"
        else
            result="ERROR"
            diff ${statdump_filepath} ${demos_folder}/${demo}.txt >> toGround/doom.log 2>&1
        fi
    fi
done
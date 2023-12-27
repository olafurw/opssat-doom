#!/bin/sh

# Define the list of demos
demos="e1m7-607 impfight m1-fast m1-normal m1-simple"

# Loop through each demo
for demo in $demos
do
  # Run Chocolate Doom for each demo
  echo -e "\n\n$(date +"%Y-%m-%d %H:%M:%S") Will OPS-SAT-1 run DOOM?\n" >> toGround/doom.log
  timestamp=$(date +"%Y%m%d%H%M%S")
  ./src/chocolate-doom -nographics -nosound -nograbmouse -iwad demos/doom.wad -statdump toGround/${demo}-output-${timestamp}.txt -cdemo demos/${demo} >> toGround/doom.log 2>&1

  # Check the output
  if diff toGround/${demo}-output-${timestamp}.txt demos/${demo}.txt; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") OK - demos/${demo}" >> toGround/summary.log
  else
    echo "$(date +"%Y-%m-%d %H:%M:%S") ERROR - demos/${demo}" >> toGround/summary.log
  fi
done

